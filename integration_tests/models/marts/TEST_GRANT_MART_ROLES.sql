
{% set (prj_name, mart_dict, owner_role, future_grants_role)
        =('PROJECT', get_XXXXX_mart_dictionary(), 'SOME_OWNER', 'SOME_SECADMIN') %}
WITH
use_case_01 as (
    SELECT     
    '{{prj_name}}' as prj_name,     
    '{{mart_dict | replace("'", "\\'") }}' as mart_dict,     
    '{{future_grants_role}}' as future_grants_role, 
    '{{ sf_project_admin.grant_mart_access__sql(prj_name, mart_dict, owner_role, future_grants_role) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,
    'USE ROLE SOME_SECADMIN;' as validate_future_grants_role,

    'GRANT USAGE ON WAREHOUSE PROJECT_WH TO ROLE XXXXX_ROLE;' as validate_env_wh,
    'GRANT USAGE ON DATABASE PROJECT_QA TO ROLE XXXXX_ROLE;' as validate_env_db,
    'GRANT USAGE ON SCHEMA PROJECT_QA.XXX_SCHEMA_NAME TO ROLE XXXXX_ROLE;' as validate_env_schema,
    'GRANT SELECT ON FUTURE VIEWS IN SCHEMA PROJECT_QA.XXX_SCHEMA_NAME TO ROLE XXXXX_ROLE;' as validate_future_granted_role,
    'GRANT SELECT ON FUTURE TABLES IN SCHEMA PROJECT_QA.XXX_SCHEMA_NAME TO ROLE PROJECT_QA_RO;' as validate_future_ro
)
, use_case_02 as (
    SELECT     
    '{{prj_name}}' as prj_name,     
    '{{mart_dict | replace("'", "\\'") }}' as mart_dict,     
    '{{future_grants_role}}' as future_grants_role, 
    '{{ sf_project_admin.grant_mart_access__sql(prj_name, mart_dict, owner_role, future_grants_role) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,
    'USE ROLE SOME_SECADMIN;' as validate_future_grants_role,

    'GRANT USAGE ON WAREHOUSE PROJECT_WH TO ROLE XXXXX_ROLE;' as validate_env_wh,
    'GRANT USAGE ON DATABASE PROJECT_PROD TO ROLE XXXXX_ROLE;' as validate_env_db,
    'GRANT USAGE ON SCHEMA PROJECT_PROD.XXX_SCHEMA_NAME TO ROLE XXXXX_ROLE;' as validate_env_schema,
    'GRANT SELECT ON FUTURE VIEWS IN SCHEMA PROJECT_PROD.XXX_SCHEMA_NAME TO ROLE XXXXX_ROLE;' as validate_future_granted_role,
    'GRANT SELECT ON FUTURE TABLES IN SCHEMA PROJECT_PROD.XXX_SCHEMA_NAME TO ROLE PROJECT_PROD_RO;' as validate_future_ro
)
, use_case_03 as (
    SELECT     
    '{{prj_name}}' as prj_name,     
    '{{mart_dict | replace("'", "\\'") }}' as mart_dict,     
    '{{future_grants_role}}' as future_grants_role, 
    '{{ sf_project_admin.grant_mart_access__sql(prj_name, mart_dict, owner_role, future_grants_role) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,
    'USE ROLE SOME_SECADMIN;' as validate_future_grants_role,
    'GRANT USAGE ON WAREHOUSE PROJECT_WH TO ROLE AI_TEAM_ROLE;' as validate_env_wh,
    'GRANT USAGE ON DATABASE PROJECT_PROD TO ROLE AI_TEAM_ROLE;' as validate_env_db,
    'GRANT USAGE ON SCHEMA PROJECT_PROD.PRJ_MART_AI_TEAM TO ROLE AI_TEAM_ROLE;' as validate_env_schema,
    'GRANT SELECT ON FUTURE VIEWS IN SCHEMA PROJECT_PROD.PRJ_MART_AI_TEAM TO ROLE AI_TEAM_ROLE;' as validate_future_granted_role,
    'GRANT SELECT ON FUTURE TABLES IN SCHEMA PROJECT_PROD.PRJ_MART_AI_TEAM TO ROLE PROJECT_PROD_RO;' as validate_future_ro
)

SELECT * FROM use_case_01
UNION ALL
SELECT * FROM use_case_02
UNION ALL
SELECT * FROM use_case_03
