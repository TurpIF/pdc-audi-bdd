#!/usr/bin/env python3

import sys
import time
from flask import Flask, send_file, request, abort, jsonify

# flask app
app = Flask(__name__, static_folder='./app', static_url_path='')

audits = []
audits.append({
    'id': 1,
    'nom': 'Audi A6 2014',
    'date': time.time()
})
audits.append({
    'id': 2,
    'nom': 'Audi A4',
    'date': time.time()
})

instances = []
instances.append({
    'id': 11,
    'idAudit': 1,
    'nbUtilisateurs': 42,
    'nbDatafiles': 23,
    'nbLogfiles': 12,
    'nbCtrlfiles': 15,
    'tailleSGA': 1337,
    'nbTablespaces': 40,
    'nbSegments': 11,
    'nbExtents': 21,
    'nbBlocs': 11,
    'tailleBlocs': 1024,
    'nbVues': 12
})
instances.append({
    'id': 12,
    'idAudit': 1,
    'nbUtilisateurs': 42,
    'nbDatafiles': 23,
    'nbLogfiles': 12,
    'nbCtrlfiles': 15,
    'tailleSGA': 1337,
    'nbTablespaces': 40,
    'nbSegments': 11,
    'nbExtents': 21,
    'nbBlocs': 11,
    'tailleBlocs': 1024,
    'nbVues': 12
})

instances.append({
    'id': 13,
    'idAudit': 2,
    'nbUtilisateurs': 42,
    'nbDatafiles': 23,
    'nbLogfiles': 12,
    'nbCtrlfiles': 15,
    'tailleSGA': 1337,
    'nbTablespaces': 40,
    'nbSegments': 11,
    'nbExtents': 21,
    'nbBlocs': 11,
    'tailleBlocs': 1024,
    'nbVues': 12
})

# fix for index page
@app.route('/')
def index():
    return app.send_static_file('index.html')

@app.route('/api/audits/')
def api_audits():
    res_audits = []
    for audit in audits:
        ins = list(filter(lambda x: x['idAudit'] == audit['id'], instances))
        res_audits.append({
            'id': audit['id'],
            'name': audit['nom'],
            'date': audit['date'],
            'nbInstances': len(ins),
            'nbUtilisateurs': sum(map(lambda x: x['nbUtilisateurs'], ins)),
            'nbDatafiles': sum(map(lambda x: x['nbDatafiles'], ins)),
            'nbLogfiles': sum(map(lambda x: x['nbLogfiles'], ins)),
            'nbCtrlfiles': sum(map(lambda x: x['nbCtrlfiles'], ins)),
            'tailleSGA': sum(map(lambda x: x['tailleSGA'], ins)),
        })

    return jsonify(**{'results': res_audits, 'nbr': 1})

@app.route('/api/audits/<int:id_audit>/instances/')
def api_instances(id_audit):
    return jsonify(**{'results': [{'id': 1, 'name': 'instance'}], 'nbr': 1})

@app.route('/api/audits/<int:id_audit>/instances/<int:id_instance>/servers/')
def api_servers(id_audit, id_instance):
    return jsonify(**{'results': [{'id': 1, 'name': 'server'}], 'nbr': 1})

@app.route('/api/audits/<int:id_audit>/instances/<int:id_instance>/tables/')
def api_tables(id_audit, id_instance):
    return jsonify(**{'results': [{'id': 1, 'name': 'table'}], 'nbr': 1})

@app.route('/api/audits/<int:id_audit>/instances/<int:id_instance>/tables/<int:id_table>/columns/')
def api_columns(id_audit, id_instance, id_table):
    return jsonify(**{'results': [{'id': 1, 'name': 'column'}], 'nbr': 1})

@app.route('/api/audits/<int:id_audit>')
def api_get_audit(id_audit):
    abort(404)

@app.route('/api/audits/<int:id_audit>')
def api_get_instance(id_audit):
    abort(404)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug='--debug' in sys.argv, port=8888, threaded=True)
