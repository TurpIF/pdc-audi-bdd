-- Groupement par audit
SELECT
COUNT(audit.id) AS nbAudit,
COUNT(instance.id) AS nbInstance,
COUNT(serveur.id) AS nbServeur,
COUNT(vtable.id) AS nbTable,
COUNT(colonne.nom + colonne.idTable) AS nbColonne,
audit.nom AS name,
audit.date AS date,
SUM(instance.nbUtilisateurs) AS nbUtilisateurs,
SUM(instance.nbDatafiles) AS nbDatafiles,
SUM(instance.nbCtrlFiles) AS nbCtrlfiles,
AVG(instance.tailleSGA) AS tailleSGA,
SUM(instance.nbTablespaces) AS nbTablespaces,
SUM(instance.nbSegments) AS nbSegments,
SUM(instance.nbExtents) AS nbExtents,
SUM(instance.nbBlocs) AS nbBlocs,
AVG(instance.tailleBlocs) AS tailleBlocs,
SUM(instance.nbVues) AS nbVues,
SUM(vtable.hasIndex) * 100 / COUNT(vtable.id) AS ratioIndex,
SUM(vtable.hasPK_) * 100 / COUNT(vtable.id) AS ratioPK,
SUM(vtable.hasFK) * 100 / COUNT(vtable.id) AS ratioFK,
AVG(vtable.nbEntrees) AS nbEntrees,
AVG(colonne.nbValeursNULL / vtable.nbEntrees) AS ratioValeursNULL,
AVG(colonne.nbValeursDifferentes / vtable.nbEntrees) AS ratioValeursDifferentes,
AVG(colonne.largeurColonne) AS largeurColonne
FROM audit
LEFT JOIN instance ON audit.id=instance.idAudit
LEFT JOIN serveur ON instance.id=serveur.idInstance
LEFT JOIN (
  SELECT
  *,
  IF(nbIndex > 0, 1, 0) AS hasIndex,
  IF(hasPK, 1, 0) AS hasPK_,
  IF(nbFK > 0, 1, 0) AS hasFK
  FROM table_
) vtable ON instance.id=vtable.idInstance
LEFT JOIN colonne ON vtable.id=colonne.idTable
GROUP BY audit.id;

-- Groupement par instance d'un audit
SELECT
COUNT(instance.id) AS nbInstance,
COUNT(serveur.id) AS nbServeur,
COUNT(vtable.id) AS nbTable,
COUNT(colonne.nom + colonne.idTable) AS nbColonne,
audit.nom AS name,
audit.date AS date,
SUM(instance.nbUtilisateurs) AS nbUtilisateurs,
SUM(instance.nbDatafiles) AS nbDatafiles,
SUM(instance.nbCtrlFiles) AS nbCtrlfiles,
AVG(instance.tailleSGA) AS tailleSGA,
SUM(instance.nbTablespaces) AS nbTablespaces,
SUM(instance.nbSegments) AS nbSegments,
SUM(instance.nbExtents) AS nbExtents,
SUM(instance.nbBlocs) AS nbBlocs,
AVG(instance.tailleBlocs) AS tailleBlocs,
SUM(instance.nbVues) AS nbVues,
SUM(vtable.hasIndex) * 100 / COUNT(vtable.id) AS ratioIndex,
SUM(vtable.hasPK_) * 100 / COUNT(vtable.id) AS ratioPK,
SUM(vtable.hasFK) * 100 / COUNT(vtable.id) AS ratioFK,
AVG(vtable.nbEntrees) AS nbEntrees,
AVG(colonne.nbValeursNULL / vtable.nbEntrees) AS ratioValeursNULL,
AVG(colonne.nbValeursDifferentes / vtable.nbEntrees) AS ratioValeursDifferentes,
AVG(colonne.largeurColonne) AS largeurColonne
FROM audit
LEFT JOIN instance ON audit.id=instance.idAudit
LEFT JOIN serveur ON instance.id=serveur.idInstance
LEFT JOIN (
  SELECT
  *,
  IF(nbIndex > 0, 1, 0) AS hasIndex,
  IF(hasPK, 1, 0) AS hasPK_,
  IF(nbFK > 0, 1, 0) AS hasFK
  FROM table_
) vtable ON instance.id=vtable.idInstance
LEFT JOIN colonne ON vtable.id=colonne.idTable
WHERE audit.id=42
GROUP BY instance.id;

-- Groupement par tables d'une instance
SELECT
COUNT(vtable.id) AS nbTable,
COUNT(colonne.nom + colonne.idTable) AS nbColonne,
instance.nbUtilisateurs AS nbUtilisateurs,
instance.nbDatafiles AS nbDatafiles,
instance.nbCtrlFiles AS nbCtrlfiles,
instance.tailleSGA AS tailleSGA,
instance.nbTablespaces AS nbTablespaces,
instance.nbSegments AS nbSegments,
instance.nbExtents AS nbExtents,
instance.nbBlocs AS nbBlocs,
instance.tailleBlocs AS tailleBlocs,
instance.nbVues AS nbVues,
SUM(vtable.hasIndex) * 100 / COUNT(vtable.id) AS ratioIndex,
SUM(vtable.hasPK_) * 100 / COUNT(vtable.id) AS ratioPK,
SUM(vtable.hasFK) * 100 / COUNT(vtable.id) AS ratioFK,
AVG(vtable.nbEntrees) AS nbEntrees,
AVG(colonne.nbValeursNULL / vtable.nbEntrees) AS ratioValeursNULL,
AVG(colonne.nbValeursDifferentes / vtable.nbEntrees) AS ratioValeursDifferentes,
AVG(colonne.largeurColonne) AS largeurColonne
FROM instance
LEFT JOIN (
  SELECT
  *,
  IF(nbIndex > 0, 1, 0) AS hasIndex,
  IF(hasPK, 1, 0) AS hasPK_,
  IF(nbFK > 0, 1, 0) AS hasFK
  FROM table_
) vtable ON instance.id=vtable.idInstance
LEFT JOIN colonne ON vtable.id=colonne.idTable
WHERE instance.id=42
GROUP BY vtable.id;

-- Groupement par colonnes d'une table
SELECT
COUNT(*) AS nbColonne,
table_.nbIndex AS nbIndex,
table_.hasPK_ AS hasPK,
table_.nbFK AS nbFK,
table_.nbEntrees AS nbEntrees,
AVG(colonne.nbValeursNULL / table_.nbEntrees) AS ratioValeursNULL,
AVG(colonne.nbValeursDifferentes / table_.nbEntrees) AS ratioValeursDifferentes,
AVG(colonne.largeurColonne) AS largeurColonne
FROM table_
LEFT JOIN colonne ON table_.id=colonne.idTable
WHERE table_.id=42
GROUP BY (colonne.name, colonne.idTable);

-- Sélection par colonne
SELECT
colonne.nbValeursNULL AS nbValeursNULL,
colonne.nbValeursDifferentes AS nbValeursDifferentes,
colonne.largeurColonne AS largeurColonne,
colonne.nbValeursNULL / table_.nbEntrees AS ratioValeursNULL,
colonne.nbValeursDifferentes / table_.nbEntrees AS ratioValeursDifferentes
FROM colonne
LEFT JOIN table_ ON table_.id=colonne.idTable
WHERE colonne.name=42 AND colonne.idTable=42;
