SELECT 'UPDATE audit.colonne SET idTable =', t.id ,';' FROM audit.table_ t INNER JOIN audit.colonne c
ON replace(replace(t.owner,' ', ''), '\n', '') = replace(replace(c.owner,' ', ''), '\n', '') AND replace(replace(t.nomTable,' ', ''), '\n', '') = replace(replace(c.nomTable,' ', ''), '\n', '')
WHERE t.idInstance = 21 AND c.idTable = 6723 INTO OUTFILE 'lien_tab_col_final.sql';
