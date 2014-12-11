SET VERIFY OFF;
SET ECHO OFF;
SET HEAD OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET PAGES 0;
SPOOL 'colonne_up_final3.sql'

    -- type
    SELECT
        ' UPDATE audit.colonne SET type=''',data_type,''' WHERE nom =trim( ''', column_name ,''' )AND nomTable =trim( ''', table_name ,''' ) AND owner=trim(''', owner,
        ''');'
    FROM DBA_TAB_COLUMNS
    WHERE owner != 'SYSTEM' AND owner !='SYS' AND owner !='CTXSYS' AND owner != 'DMSYS' AND owner != 'DSSYS' AND owner != 'EXFSYS' AND owner!= 'LBACSYS' AND owner != 'MDSYS' and owner != 'ORDSYS' and owner != 'TSMSYS' AND owner != 'SYSMAN' AND owner != 'XDB' AND owner != 'WMSYS' AND owner != 'OLAPSYS' AND NOT table_name LIKE 'BIN%';

SPOOL OFF
SET ECHO ON;
SET HEAD ON;
SET FEEDBACK ON;
SET SERVEROUTPUT OFF;
SET VERIFY ON;
