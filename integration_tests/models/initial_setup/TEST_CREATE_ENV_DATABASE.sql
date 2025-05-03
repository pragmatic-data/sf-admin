WITH
use_case_01 as (
    {% set (prj_name,  env_name, owner_role, creator_role)
          =('SAMPLE', 'XDEV', 'SOME_OWNER', 'SOME_CREATOR') %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{creator_role}}' as creator_role,     
    '{{ sf_project_admin.create_env_database(prj_name, env_name, owner_role, creator_role) |e }}' as result,

    'CREATE DATABASE IF NOT EXISTS SAMPLE_XDEV' as validate_env_db_creation,
    'USE ROLE SOME_CREATOR;' as validate_creator_role,
    'GRANT OWNERSHIP ON DATABASE SAMPLE_XDEV TO ROLE SOME_OWNER;' as validate_owner_role_owns_db 

)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
