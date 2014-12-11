#!/usr/bin/env python3

import sys
import time
from flask import Flask, send_file, request, abort, jsonify
import pymysql

# flask app
app = Flask(__name__, static_folder='./app', static_url_path='')

# mysql conn
db_conn = pymysql.connect(host='127.0.0.1', port=3306, user='root', passwd='tanukitanuki', db='audit')

# fix for index page
@app.route('/')
def index():
    return app.send_static_file('index.html')

@app.route('/api/audits/')
def api_audits():
    cur = db_conn.cursor()
    cur.execute('''
SELECT
  id,
  nom AS name,
  date,
  nbInstance,
  nbTable,
  nbColonne AS nbAttributs,
  nbUtilisateurs,
  nbDatafiles,
  nbCtrlfiles,
  tailleSGA,
  nbTablespaces,
  nbSegments,
  nbExtents,
  nbBlocs,
  tailleBlocs,
  nbVues,
  nbVues * 100 / nbTable AS ratioVues,
  ratioIndex,
  ratioPK,
  ratioFK,
  nbEntrees,
  ratioValeursNULL,
  ratioValeursDifferentes,
  largeurColonne
FROM audit
LEFT JOIN
(
  SELECT
  audit.id AS idA1,
  COUNT(instance.id) AS nbInstance,
  AVG(instance.nbUtilisateurs) AS nbUtilisateurs,
  SUM(instance.nbDatafiles) AS nbDatafiles,
  SUM(instance.nbCtrlFiles) AS nbCtrlfiles,
  AVG(instance.tailleSGA) AS tailleSGA,
  SUM(instance.nbTablespaces) AS nbTablespaces,
  SUM(instance.nbSegments) AS nbSegments,
  SUM(instance.nbExtents) AS nbExtents,
  SUM(instance.nbBlocs) AS nbBlocs,
  AVG(instance.tailleBlocs) AS tailleBlocs,
  SUM(instance.nbVues) AS nbVues
  FROM audit
  LEFT JOIN instance ON instance.idAudit=audit.id
  GROUP BY audit.id
) vinstance ON vinstance.idA1=audit.id
LEFT JOIN
(
  SELECT
  audit.id AS idA2,
  COUNT(vtable.id) AS nbTable,
  SUM(vtable.hasIndex) * 100 / COUNT(vtable.id) AS ratioIndex,
  SUM(vtable.hasPK_) * 100 / COUNT(vtable.id) AS ratioPK,
  SUM(vtable.hasFK) * 100 / COUNT(vtable.id) AS ratioFK,
  AVG(vtable.nbEntrees) AS nbEntrees
  FROM audit
  LEFT JOIN instance ON instance.idAudit=audit.id
  LEFT JOIN (
    SELECT
    *,
    IF(nbIndex > 0, 1, 0) AS hasIndex,
    IF(hasPK, 1, 0) AS hasPK_,
    IF(nbFK > 0, 1, 0) AS hasFK
    FROM table_
  ) vtable ON instance.id=vtable.idInstance
  GROUP BY audit.id
) vtable ON vtable.idA2=audit.id
LEFT JOIN
(
  SELECT
  audit.id AS idA3,
  COUNT(colonne.nom) AS nbColonne,
  AVG(colonne.nbValeursNULL / table_.nbEntrees) AS ratioValeursNULL,
  AVG(colonne.nbValeursDifferentes / table_.nbEntrees) AS ratioValeursDifferentes,
  AVG(colonne.largeurColonne) AS largeurColonne
  FROM audit
  LEFT JOIN instance ON instance.idAudit=audit.id
  LEFT JOIN table_ ON table_.idInstance=instance.id
  LEFT JOIN colonne ON colonne.idTable=table_.id
  GROUP BY audit.id
) vcolonne ON vcolonne.idA3=audit.id
    ''')
    description = cur.description
    res_audits = [{k[0]: str(e) for k, e in zip(description, row)} for row in cur.fetchall()]
    cur.close()

    return jsonify(**{'results': res_audits, 'nbr': len(res_audits)})

@app.route('/api/audits/<int:id_audit>/instances/')
def api_instances(id_audit):
    cur = db_conn.cursor()
    cur.execute('''
SELECT
  id,
  nbTable,
  nbColonne AS nbAttributs,
  nbUtilisateurs,
  nbDatafiles,
  nbCtrlfiles,
  tailleSGA,
  nbTablespaces,
  nbSegments,
  nbExtents,
  nbBlocs,
  tailleBlocs,
  nbVues,
  nbVues * 100 / nbTable AS ratioVues,
  ratioIndex,
  ratioPK,
  ratioFK,
  nbEntrees,
  ratioValeursNULL,
  ratioValeursDifferentes,
  largeurColonne
FROM instance
LEFT JOIN
(
  SELECT
  instance.id AS idI1,
  COUNT(vtable.id) AS nbTable,
  SUM(vtable.hasIndex) * 100 / COUNT(vtable.id) AS ratioIndex,
  SUM(vtable.hasPK_) * 100 / COUNT(vtable.id) AS ratioPK,
  SUM(vtable.hasFK) * 100 / COUNT(vtable.id) AS ratioFK,
  AVG(vtable.nbEntrees) AS nbEntrees
  FROM instance
  LEFT JOIN (
    SELECT
    *,
    IF(nbIndex > 0, 1, 0) AS hasIndex,
    IF(hasPK, 1, 0) AS hasPK_,
    IF(nbFK > 0, 1, 0) AS hasFK
    FROM table_
  ) vtable ON instance.id=vtable.idInstance
  GROUP BY instance.id
) vtable ON vtable.idI1=instance.id
LEFT JOIN
(
  SELECT
  instance.id AS idI2,
  COUNT(colonne.nom + colonne.idTable) AS nbColonne,
  AVG(colonne.nbValeursNULL / table_.nbEntrees) AS ratioValeursNULL,
  AVG(colonne.nbValeursDifferentes / table_.nbEntrees) AS ratioValeursDifferentes,
  AVG(colonne.largeurColonne) AS largeurColonne
  FROM instance
  LEFT JOIN table_ ON table_.idInstance=instance.id
  LEFT JOIN colonne ON colonne.idTable=table_.id
  GROUP BY instance.id
) vcolonne ON vcolonne.idI2=instance.id
WHERE idAudit=%d
    ''' % id_audit)
    description = cur.description
    res_audits = [{k[0]: str(e) for k, e in zip(description, row)} for row in cur.fetchall()]
    cur.close()

    return jsonify(**{'results': res_audits, 'nbr': len(res_audits)})

@app.route('/api/audits/<int:id_audit>/instances/<int:id_instance>/servers/')
def api_servers(id_audit, id_instance):
    return jsonify(**{'results': [{'id': 1, 'name': 'server'}], 'nbr': 1})

@app.route('/api/audits/<int:id_audit>/instances/<int:id_instance>/tables/')
def api_tables(id_audit, id_instance):
    cur = db_conn.cursor()
    cur.execute('''
SELECT
  id,
  TRIM(nomTable) AS name,
  nbColonne AS nbAttributs,
  nbIndex,
  IF(hasPK, 1, 0) AS nbPK,
  nbFK,
  nbEntrees,
  ratioValeursNULL,
  ratioValeursDifferentes,
  largeurColonne
FROM table_
LEFT JOIN
(
  SELECT
  table_.id AS idT,
  COUNT(colonne.nom + colonne.idTable) AS nbColonne,
  AVG(colonne.nbValeursNULL / table_.nbEntrees) AS ratioValeursNULL,
  AVG(colonne.nbValeursDifferentes / table_.nbEntrees) AS ratioValeursDifferentes,
  AVG(colonne.largeurColonne) AS largeurColonne
  FROM table_
  LEFT JOIN colonne ON colonne.idTable=table_.id
  GROUP BY table_.id
) vcolonne ON vcolonne.idT=table_.id
WHERE idInstance=%d
    ''' % id_instance)
    description = cur.description
    res_audits = [{k[0]: str(e) for k, e in zip(description, row)} for row in cur.fetchall()]
    cur.close()

    return jsonify(**{'results': res_audits, 'nbr': len(res_audits)})

@app.route('/api/audits/<int:id_audit>/instances/<int:id_instance>/tables/<int:id_table>/columns/')
def api_columns(id_audit, id_instance, id_table):
    cur = db_conn.cursor()
    cur.execute('''
SELECT * FROM colonne
WHERE idTable=%d
    ''' % id_table)
    description = cur.description
    res_audits = [{k[0]: str(e) for k, e in zip(description, row)} for row in cur.fetchall()]
    cur.close()
    return jsonify(**{'results': res_audits, 'nbr': len(res_audits)})

@app.route('/api/audits/<int:id_audit>')
def api_get_audit(id_audit):
    abort(404)

@app.route('/api/audits/<int:id_audit>')
def api_get_instance(id_audit):
    abort(404)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug='--debug' in sys.argv, port=8888, threaded=True)
