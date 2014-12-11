-- A parametrer avec l'id de l'audit...
SET VERIFY OFF;
SET ECHO OFF;
SET HEAD OFF;
SET FEEDBACK OFF;
SET SERVEROUTPUT ON;
SET PAGES 0;
SPOOL 'instances_final.sql'

PROMPT INSERT INTO audit.instance(idAudit) VALUES(1);;
SELECT 'UPDATE audit.instance SET nbUtilisateurs=', count(*), ' WHERE id = last_insert_id();' FROM DBA_USERS ;
SELECT 'UPDATE audit.instance SET nbDatafiles=', count(*), ' WHERE id = last_insert_id();' FROM v$datafile;
SELECT 'UPDATE audit.instance SET nblogfiles=', count(*), ' WHERE id = last_insert_id();' FROM v$logfile ;
SELECT 'UPDATE audit.instance SET nbCtrlFiles=', count(*), ' WHERE id = last_insert_id();' FROM v$controlfile;
SELECT 'UPDATE audit.instance SET tailleSGA=', sum(value), ' WHERE id = last_insert_id();' FROM v$sga;
SELECT 'UPDATE audit.instance SET nbTablespaces=', count(*), ' WHERE id = last_insert_id();' FROM dba_tablespaces;
SELECT 'UPDATE audit.instance SET nbSegments=', count(*), ' WHERE id = last_insert_id();' FROM dba_segments;
SELECT 'UPDATE audit.instance SET nbExtents=', sum(extents), ' WHERE id = last_insert_id();' FROM dba_segments;
SELECT 'UPDATE audit.instance SET nbBlocs=', sum(blocks), ' WHERE id = last_insert_id();' FROM dba_segments;
SELECT 'UPDATE audit.instance SET nbVues=', count(*), ' WHERE id = last_insert_id();' FROM dba_views
WHERE owner != 'SYSTEM' AND owner !='SYS' AND owner !='CTXSYS' AND owner != 'DMSYS' AND owner != 'DSSYS' AND owner != 'EXFSYS' AND owner!= 'LBACSYS' AND owner != 'MDSYS' and owner != 'ORDSYS' and owner != 'TSMSYS' AND owner != 'SYSMAN' AND owner != 'XDB' AND owner != 'WMSYS' AND owner != 'OLAPSYS';



SPOOL OFF
SET ECHO ON;
SET HEAD ON;
SET FEEDBACK ON;
SET SERVEROUTPUT OFF;
SET VERIFY ON;
