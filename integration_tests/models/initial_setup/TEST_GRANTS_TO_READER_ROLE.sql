WITH
use_case_01 as (
    {% set (prj_name,  env_name, owner_role, future_grants_role, single_WH)
          =('SAMPLE', 'XDEV', 'SOME_OWNER', 'SOME_SECURITYADMIN', true) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{future_grants_role}}' as future_grants_role, 
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.grants_to_reader_role(prj_name, env_name, owner_role, future_grants_role, single_WH) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,    
    'GRANT USAGE ON WAREHOUSE SAMPLE_WH TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_prj_wh,
    'GRANT USAGE ON DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_env_db,
    'GRANT USAGE ON ALL SCHEMAS IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_env_db_schemata,
    'GRANT USAGE ON FUTURE SCHEMAS IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_future_env_db_schemata,
    'GRANT SELECT ON ALL TABLES IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_env_db_tables,
    'GRANT SELECT ON FUTURE TABLES IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_future_env_db_tables,
    'GRANT SELECT ON ALL VIEWS IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_env_db_views,
    'GRANT SELECT ON FUTURE VIEWS IN DATABASE SAMPLE_XDEV TO ROLE SAMPLE_XDEV_RO;' as validate_usage_on_future_env_db_views
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
