WITH
use_case_01 as (
    {% set (prj_name,  env_name, owner_role, useradmin_role)
          =('SAMPLE', 'XDEV', 'SOME_OWNER', 'SOME_USERADMIN') %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{useradmin_role}}' as useradmin_role,     
    '{{ sf_project_admin.create_functional_roles(prj_name, env_name, owner_role, useradmin_role) |e }}' as result,

    'CREATE ROLE IF NOT EXISTS SAMPLE_XDEV_RW' as validate_env_RW_role_creation,
    'GRANT ROLE SAMPLE_XDEV_RW TO ROLE SOME_OWNER;' as validate_RW_to_owner_role,
    'CREATE ROLE IF NOT EXISTS SAMPLE_XDEV_RO' as validate_env_RO_role_creation,
    'GRANT ROLE SAMPLE_XDEV_RO TO ROLE SOME_OWNER;' as validate_RO_to_owner_role,
    'USE ROLE SOME_USERADMIN;' as validate_useradmin_role
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
