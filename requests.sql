-- Groupement par audit
SELECT
  id,
  nom AS name,
  date,
  nbInstance,
  nbTable,
  nbColonne,
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
  COUNT(colonne.nom + colonne.idTable) AS nbColonne,
  AVG(colonne.nbValeursNULL / table_.nbEntrees) AS ratioValeursNULL,
  AVG(colonne.nbValeursDifferentes / table_.nbEntrees) AS ratioValeursDifferentes,
  AVG(colonne.largeurColonne) AS largeurColonne
  FROM audit
  LEFT JOIN instance ON instance.idAudit=audit.id
  LEFT JOIN table_ ON table_.idInstance=instance.id
  LEFT JOIN colonne ON colonne.idTable=table_.id
  GROUP BY audit.id
) vcolonne ON vcolonne.idA3=audit.id



SELECT
  id,
  nbTable,
  nbColonne,
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
WHERE idAudit=




SELECT
  id,
  nomTable AS name,
  nbColonne,
  nbIndex,
  hasPK,
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
WHERE idInstance=



SELECT
  nom AS name,
  nbColonne,
  nbIndex,
  hasPK,
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
WHERE idInstance=


SELECT
COUNT(DISTINCT instance.id) AS nbInstance,
COUNT(DISTINCT serveur.id) AS nbServeur,
COUNT(DISTINCT vtable.id) AS nbTable,
COUNT(DISTINCT colonne.nom + colonne.idTable) AS nbColonne,
audit.nom AS name,
audit.date AS date,
AVG(instance.nbUtilisateurs) AS nbUtilisateurs,
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
COUNT(DISTINCT serveur.id) AS nbServeur,
COUNT(DISTINCT vtable.id) AS nbTable,
COUNT(DISTINCT colonne.nom + colonne.idTable) AS nbColonne,
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
COUNT(DISTINCT colonne.nom + colonne.idTable) AS nbColonne,
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
