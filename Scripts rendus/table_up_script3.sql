SET VERIFY OFF;
SET ECHO OFF;
SET HEAD OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET PAGES 0;
SPOOL 'table_up_inter3.sql'

PROMPT SET VERIFY OFF;
PROMPT SET ECHO OFF;
PROMPT SET HEAD OFF;
PROMPT SET FEEDBACK OFF;
PROMPT SET SERVEROUTPUT ON;
PROMPT SET PAGES 0;
PROMPT SPOOL 'table_up_final3.sql'

-- A paramétrer par rapport à l'id d'instance

--nbEntrees
    SELECT
		'SELECT
			''UPDATE audit.table_ SET nbEntrees='',count(*),'' WHERE nomTable =''''',
			trim(replace(table_name, '''', '''''')) ,'''''AND idInstance = 21 AND owner=''''', trim(replace(owner, '''', '''''')), ''''';''
		FROM ',owner,'.',table_name, ';'
	FROM DBA_ALL_TABLES AT
	WHERE owner != 'SYSTEM' AND owner !='SYS' AND owner !='CTXSYS' AND owner != 'DMSYS' AND owner != 'DSSYS' AND owner != 'EXFSYS' AND owner!= 'LBACSYS' AND owner != 'MDSYS' and owner != 'ORDSYS' and owner != 'TSMSYS' AND owner != 'SYSMAN' AND owner != 'XDB' AND owner != 'WMSYS' AND owner != 'OLAPSYS' AND iot_type IS NULL
		AND NOT EXISTS(SELECT * FROM DBA_NESTED_TABLES NT WHERE NT.OWNER = AT.owner AND NT.TABLE_NAME = AT.table_name);

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
