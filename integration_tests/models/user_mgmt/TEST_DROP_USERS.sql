{% set users_dict_yaml -%}
dbt_executor: XXXXX_DBT_EXECUTOR

readers:
  - POWERBI_READER
  - READER@COMPAY.COM

users_to_delete:
  - SOME_USER_NAME_TO_DROP
#  - OTHER_USER_NAME_TO_DROP

SOME_ROLE:                      # An EXISTING role to be assigned to the list of users
 - ROBERTO_ZAGNI_DEVELOPER

{%- endset %}
{%- set users_dict = fromyaml(users_dict_yaml) %}
{%- set (executor_role_name, developer_role_name, reader_role_name) 
            = sf_project_admin.get_default_org_role_names(prj_name = 'SAMPLE') %}

WITH
use_case_01 as (
    {% set (user_list)
          =(users_dict.users_to_delete) %}
    SELECT 
    '{{ user_list | replace("'", "\\'") }}' as user_list,
    '{{ sf_project_admin.drop_users(user_list)|e }}' as result,

    '{{'DROP USER IF EXISTS "SOME_USER_NAME_TO_DROP";'|e }}' as validate_user1, 
    '' as validate_user2
)
, use_case_02 as (
    {% set (user_list)
          =(users_dict['users_to_delete']) %}
    SELECT 
    '{{ user_list | replace("'", "\\'") }}' as user_list,
    '{{ sf_project_admin.drop_users(user_list)|e }}' as result,

    '{{'DROP USER IF EXISTS "SOME_USER_NAME_TO_DROP";'|e }}' as validate_user1, 
    '' as validate_user2
)

SELECT * FROM use_case_01
UNION ALL
SELECT * FROM use_case_02
