SET VERIFY OFF;
SET ECHO OFF;
SET HEAD OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET PAGES 0;
SPOOL 'colonne_up_inter2.sql'

PROMPT SET VERIFY OFF;
PROMPT SET ECHO OFF;
PROMPT SET HEAD OFF;
PROMPT SET FEEDBACK OFF;
PROMPT SET SERVEROUTPUT ON;
PROMPT SET ERRORL OFF;
PROMPT SET PAGES 0;
PROMPT SPOOL 'colonne_up_final2.sql'

-- nbValeursDiff
	SELECT
		'SELECT	'' UPDATE audit.colonne SET nbValeursDifferentes='',count(*),''
			WHERE nom =trim( ''''', column_name ,
		     	''''' )AND nomTable =trim( ''''', table_name ,''''' ) AND owner=trim( ''''', owner,
 			''''' );'' FROM ',owner,'.',table_name,' GROUP BY ',column_name,';'
	FROM DBA_TAB_COLUMNS
	WHERE owner != 'SYSTEM' AND owner !='SYS' AND owner !='CTXSYS' AND owner != 'DMSYS' AND owner != 'DSSYS' AND owner != 'EXFSYS' AND owner!= 'LBACSYS' AND owner != 'MDSYS' and owner != 'ORDSYS' and owner != 'TSMSYS' AND owner != 'SYSMAN' AND owner != 'XDB' AND owner != 'WMSYS' AND owner != 'OLAPSYS' AND NOT table_name LIKE 'BIN%' AND data_type NOT IN ('CLOB', 'LOB', 'BLOB');

    PROMPT SPOOL OFF
    PROMPT SET ECHO ON;
    PROMPT SET HEAD ON;
    PROMPT SET FEEDBACK ON;
    PROMPT SET SERVEROUTPUT OFF;
	PROMPT SET ERRORL ON;
    PROMPT SET VERIFY ON;

SPOOL OFF
SET ECHO ON;
SET HEAD ON;
SET FEEDBACK ON;
SET SERVEROUTPUT OFF;
SET VERIFY ON;
