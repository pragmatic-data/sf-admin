WITH
use_case_01 as (
    {% set (initial_dbt_executor_pw, dbt_executor_user_name, dbt_executor_role_name, default_wh_name, default_db_name)
          =('Change.ME', 'PRJ_DBT_EXECUTOR', 'DBT_EXECUTOR_ROLE', 'PROJECT_DEV_WH', 'PROJECT_DEV' ) %}
    SELECT 
    '{{initial_dbt_executor_pw}}' as initial_dbt_executor_pw, 
    '{{dbt_executor_user_name}}' as dbt_executor_user_name, 
    '{{dbt_executor_role_name}}' as dbt_executor_role_name, 
    '{{default_wh_name}}' as default_wh_name, 
    '{{default_db_name}}' as default_db_name,
    '{{ sf_project_admin.setup_dbt_user(
        dbt_executor_role_name, dbt_executor_user_name, initial_dbt_executor_pw, default_wh_name, default_db_name) |e }}' as result,

    '{{'CREATE USER IF NOT EXISTS "PRJ_DBT_EXECUTOR"'|e }}' as validate_user_name,
    '{{"PASSWORD = 'Change.ME'" | e }}' as validate_pw,
    'MUST_CHANGE_PASSWORD = TRUE' as validate_must_change_pw,
    '{{"DEFAULT_ROLE = 'DBT_EXECUTOR_ROLE'" | e }}' as validate_default_role,
    '{{"DEFAULT_WAREHOUSE = 'PROJECT_DEV_WH'"|e }}' as validate_warehouse,
    '{{"DEFAULT_NAMESPACE = 'PROJECT_DEV'"|e }}' as validate_db
)

SELECT * FROM use_case_01