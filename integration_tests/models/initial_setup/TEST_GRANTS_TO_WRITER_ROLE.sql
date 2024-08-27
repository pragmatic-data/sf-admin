WITH
use_case_01 as (
    {% set (prj_name,  env_name, owner_role, single_WH)
          =('SAMPLE', 'XDEV', 'SOME_OWNER', true) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.grants_to_writer_role(prj_name, env_name, owner_role, single_WH) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,    
    'GRANT USAGE ON WAREHOUSE SAMPLE_WH TO ROLE SAMPLE_XDEV_RW;' as validate_usage_on_prj_wh,
    'GRANT USAGE ON DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RW;' as validate_usage_on_env_db,
    'GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RW;' as validate_ownership_on_env_db_schemata,
    'GRANT CREATE SCHEMA ON DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RW;' as validate_create_schema_on_env_db
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
