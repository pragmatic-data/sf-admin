WITH
use_case_01 as (
    {% set (dbt_executor_user_name, dbt_executor_role_name)
          =('PRJ_DBT_EXECUTOR', 'DBT_EXECUTOR_ROLE') %}
    SELECT 
    '{{dbt_executor_role_name}}' as dbt_executor_role_name, 
    '{{dbt_executor_user_name}}' as dbt_executor_user_name, 
    '{{ sf_project_admin.grant_role_to_user(dbt_executor_role_name, dbt_executor_user_name) |e }}' as result,

    '{{'GRANT ROLE DBT_EXECUTOR_ROLE TO USER "PRJ_DBT_EXECUTOR"'|e }}' as validate_user_name
)

SELECT * FROM use_case_01