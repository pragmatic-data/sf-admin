WITH
use_case_01 as (
    {% set (prj_name,  env_name, owner_role, creator_role, useradmin_role, single_WH)
          =('SAMPLE', 'XDEV', 'SOME_OWNER', 'SOME_CREATOR', 'SOME_USERADMIN', true) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{creator_role}}' as creator_role,     
    '{{useradmin_role}}' as useradmin_role,     
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.create_environment(prj_name, env_name, owner_role, creator_role, useradmin_role, single_WH) |e }}' as result,

    'CREATE DATABASE IF NOT EXISTS SAMPLE_XDEV;' as validate_env_db_creation,
    'CREATE ROLE IF NOT EXISTS SAMPLE_XDEV_RW' as validate_env_RW_role_creation,
    'CREATE ROLE IF NOT EXISTS SAMPLE_XDEV_RO' as validate_env_RO_role_creation,
    'GRANT USAGE ON WAREHOUSE SAMPLE_WH' as validate_single_WH,
    'GRANT OWNERSHIP ON DATABASE SAMPLE_XDEV TO ROLE SOME_OWNER;' as validate_owner_role,
    'USE ROLE SOME_CREATOR;' as validate_creator_role,
    'USE ROLE SOME_USERADMIN;' as validate_useradmin_role
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
