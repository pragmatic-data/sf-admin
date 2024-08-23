/* == Macro to run the user update as a dbt run-operation == */
{% macro refresh_user_roles___XXXXX_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}
    {% do log("Refreshing user roles for XXXXX project ", info=True) %}
    {%- set prj_name = 'SAMPLE' -%}
    {%- set useradmin_role = 'SOME_USERADMIN' -%}
    
    /* 1 Create users - Uncomment if you want users to be created from the YAML definition */
    {#% do run_query( XXXcreate_usersXXX( prj_name, get_XXXXX_user_dictionary(), useradmin_role) ) %#}
    
    /* 2 Assign default roles to users  */
    {% do run_query( setup_users( prj_name, get_XXXXX_user_dictionary(), useradmin_role) ) %}

    /* 3 Assign default roles to users  */
    {% do run_query( setup_other_users(prj_name, get_XXXXX_user_dictionary()) ) %}
    
    {% do log("Refreshed user roles for XXXXX project ", info=True) %}
{% endif %}{%- endmacro %}

{% macro get_XXXXX_user_dictionary() -%}

/* *** User setup config dictionary *** 
 * This file is used to:
 * - define the name of the DBT executor user to be created
 * - assign SF users to the default roles (Developer or Reader) (the can also be created)
 * - assign SF users to any other existing role
 * - delete SF users
 */

{% set users_dict_yaml -%}

dbt_executor: XXXXX_DBT_EXECUTOR

developers:
 - ROBERTO_ZAGNI_ADMIN          # high privilege user for interactive access and to run the "Snowflake Admin" project 
 - ROBERTO_ZAGNI_DEVELOPER      # limited privilege user for normal project development tasks
 - USER@COMPANY.COM
 - NAME.SURNAME@COMPANY.COM


readers:
  - POWERBI_READER

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

{%- endset %}

{% do return(fromyaml(users_dict_yaml)) %}

{%- endmacro %}