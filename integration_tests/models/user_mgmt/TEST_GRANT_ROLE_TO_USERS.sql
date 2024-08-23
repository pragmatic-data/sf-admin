{% set users_dict_yaml -%}
dbt_executor: XXXXX_DBT_EXECUTOR

developers:
 - ROBERTO_ZAGNI_ADMIN          # high privilege user for interactive access and to run the "Snowflake Admin" project 
 - ROBERTO_ZAGNI_DEVELOPER      # limited privilege user for normal project development tasks
 - USER@COMPANY.COM
 - NAME.SURNAME@COMPANY.COM

readers:
  - POWERBI_READER
  - READER@COMPAY.COM

users_to_delete:
  - SOME_USER_NAME_TO_DROP
#  - OTHER_USER_NAME_TO_DROP

SOME_ROLE:                      # An EXISTING role to be assigned to the list of users
 - ROBERTO_ZAGNI_DEVELOPER

AI_TEAM_ROLE:
 - AI_GUY@COMPANY.COM
 - AI_TEAM_SERVICE_USER

FINANCE_TEAM_ROLE:
 - FINANCE_GUY@COMPANY.COM
#- COMMENTED_OUT_FINANCE_TEAM_MEMBER
{%- endset %}

{%- set users_dict = fromyaml(users_dict_yaml) %}

{%- set (executor_role_name, developer_role_name, reader_role_name) 
            = sf_project_admin.get_default_org_role_names(prj_name = 'SAMPLE') %}

WITH
use_case_01 as (
    {% set (role_name, user_list)
          =(developer_role_name, users_dict.developers) %}
    SELECT 
    '{{role_name}}' as initial_dbt_executor_pw, 
    '{{ user_list | replace("'", "\\'") }}' as user_list,
    '{{ sf_project_admin.grant_role_to_users(role_name, user_list)|e }}' as result,

    '{{'GRANT ROLE SAMPLE_DEVELOPER TO USER "ROBERTO_ZAGNI_ADMIN";'|e }}' as validate_user1, 
    '{{'GRANT ROLE SAMPLE_DEVELOPER TO USER "ROBERTO_ZAGNI_DEVELOPER";'|e }}' as validate_user2, 
    '{{'GRANT ROLE SAMPLE_DEVELOPER TO USER "USER@COMPANY.COM";'|e }}' as validate_user3, 
    '{{'GRANT ROLE SAMPLE_DEVELOPER TO USER "NAME.SURNAME@COMPANY.COM";'|e }}' as validate_user4
)
, use_case_02 as (
    {% set (role_name, user_list)
          =(reader_role_name, users_dict.readers) %}
    SELECT 
    '{{role_name}}' as initial_dbt_executor_pw, 
    '{{ user_list | replace("'", "\\'") }}' as user_list,
    '{{ sf_project_admin.grant_role_to_users(role_name, user_list)|e }}' as result,

    '{{'GRANT ROLE SAMPLE_READER TO USER "POWERBI_READER";'|e }}' as validate_user1, 
    '{{'GRANT ROLE SAMPLE_READER TO USER "READER@COMPAY.COM";'|e }}' as validate_user2, 
    '' as validate_user3, 
    '' as validate_user4
)
, use_case_03 as (
    {% set (role_name, user_list)
          =('AI_TEAM_ROLE', users_dict['AI_TEAM_ROLE']) %}
    SELECT 
    '{{role_name}}' as initial_dbt_executor_pw, 
    '{{ user_list | replace("'", "\\'") }}' as user_list,
    '{{ sf_project_admin.grant_role_to_users(role_name, user_list)|e }}' as result,

    '{{'GRANT ROLE AI_TEAM_ROLE TO USER "AI_GUY@COMPANY.COM";'|e }}' as validate_user1, 
    '{{'GRANT ROLE AI_TEAM_ROLE TO USER "AI_TEAM_SERVICE_USER";'|e }}' as validate_user2, 
    '' as validate_user3, 
    '' as validate_user4
)
, use_case_04 as (
    {% set (role_name, user_list)
          =('FINANCE_TEAM_ROLE', users_dict['FINANCE_TEAM_ROLE']) %}
    SELECT 
    '{{role_name}}' as initial_dbt_executor_pw, 
    '{{ user_list | replace("'", "\\'") }}' as user_list,
    '{{ sf_project_admin.grant_role_to_users(role_name, user_list)|e }}' as result,

    '{{'GRANT ROLE FINANCE_TEAM_ROLE TO USER "FINANCE_GUY@COMPANY.COM";'|e }}' as validate_user1, 
    '' as validate_user2, 
    '' as validate_user3, 
    '' as validate_user4
)

SELECT * FROM use_case_01
UNION ALL
SELECT * FROM use_case_02
UNION ALL
SELECT * FROM use_case_03
UNION ALL
SELECT * FROM use_case_04
