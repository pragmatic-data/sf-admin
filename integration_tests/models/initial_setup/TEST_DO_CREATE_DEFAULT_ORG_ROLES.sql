WITH
use_case_01 as (
    {% set (prj_name, owner_role, useradmin_role)
          =('SAMPLE', 'SOME_OWNER', 'SOME_USERADMIN') %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{owner_role}}' as owner_role,     
    '{{useradmin_role}}' as useradmin_role,     
    '{{ sf_project_admin.do_create_default_org_roles(prj_name, owner_role, useradmin_role) |e }}' as result,

    'CREATE ROLE IF NOT EXISTS SAMPLE_DBT_EXECUTOR_ROLE' as validate_executor_role_creation,
    'GRANT ROLE SAMPLE_DBT_EXECUTOR_ROLE TO ROLE SOME_OWNER;' as validate_executor_to_owner_role,
    'CREATE ROLE IF NOT EXISTS SAMPLE_DEVELOPER' as validate_developer_role_creation,
    'GRANT ROLE SAMPLE_DEVELOPER TO ROLE SOME_OWNER;' as validate_developer_to_owner_role,
    'CREATE ROLE IF NOT EXISTS SAMPLE_READER' as validate_reader_role_creation,
    'GRANT ROLE SAMPLE_READER TO ROLE SOME_OWNER;' as validate_reader_to_owner_role,
    'USE ROLE SOME_USERADMIN;' as validate_useradmin_role
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
