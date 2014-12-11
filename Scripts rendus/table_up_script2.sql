SET VERIFY OFF;
SET ECHO OFF;
SET HEAD OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET PAGES 0;
SPOOL 'table_up_inter2.sql'

PROMPT SET VERIFY OFF;
PROMPT SET ECHO OFF;
PROMPT SET HEAD OFF;
PROMPT SET FEEDBACK OFF;
PROMPT SET SERVEROUTPUT ON;
PROMPT SET PAGES 0;
PROMPT SPOOL 'table_up_final2.sql'

-- A paramétrer par rapport à l'id d'instance

--hasPK
	SELECT
		'SELECT
			''UPDATE audit.table_ SET nbPK='',count(*),'' WHERE nomTable =''''',
			trim(replace(table_name, '''', '''''')) ,''''' AND idInstance = 21 AND owner=''''', trim(replace(owner, '''', '''''')),''''';''
		FROM dba_constraints
		WHERE table_name = ''',table_name,''' AND constraint_type=''P'';'
	FROM DBA_ALL_TABLES
	WHERE owner != 'SYSTEM' AND owner !='SYS' AND owner !='CTXSYS' AND owner != 'DMSYS' AND owner != 'DSSYS' AND owner != 'EXFSYS' AND owner!= 'LBACSYS' AND owner != 'MDSYS' and owner != 'ORDSYS' and owner != 'TSMSYS' AND owner != 'SYSMAN' AND owner != 'XDB' AND owner != 'WMSYS' AND owner != 'OLAPSYS' AND iot_type IS NULL;

PROMPT SPOOL OFF
PROMPT SET ECHO ON;
PROMPT SET HEAD ON;
PROMPT SET FEEDBACK ON;
PROMPT SET SERVEROUTPUT OFF;
PROMPT SET VERIFY ON;

SPOOL OFF
SET ECHO ON;
SET HEAD ON;
SET FEEDBACK ON;
SET SERVEROUTPUT OFF;
SET VERIFY ON;
