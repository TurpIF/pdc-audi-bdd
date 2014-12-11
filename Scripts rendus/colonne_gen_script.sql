SET VERIFY OFF;
SET ECHO OFF;
SET HEAD OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET PAGES 0;
SPOOL 'colonne_gen_final.sql'

-- Crée le tuple pour chaque colonne !
    SELECT 'INSERT INTO audit.colonne (nom, nomTable, owner, idTable) VALUES (''', column_name,''',''',  table_name, ''',''', owner, ''',10081);'
	FROM DBA_TAB_COLUMNS
	WHERE owner != 'SYSTEM' AND owner !='SYS' AND owner !='CTXSYS' AND owner != 'DMSYS' AND owner != 'DSSYS' AND owner != 'EXFSYS' AND owner!= 'LBACSYS' AND owner != 'MDSYS' and owner != 'ORDSYS' and owner != 'TSMSYS' AND owner != 'SYSMAN' AND owner != 'XDB' AND owner != 'WMSYS' AND owner != 'OLAPSYS' AND NOT table_name LIKE 'BIN%';

SPOOL OFF
SET ECHO ON;
SET HEAD ON;
SET FEEDBACK ON;
SET SERVEROUTPUT OFF;
SET VERIFY ON;
