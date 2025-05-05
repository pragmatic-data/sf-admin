{% macro get_XXXXX_user_dictionary() -%}

/* *** User setup config dictionary *** 
 * This file is used to:
 * - define the name of the DBT executor user to be created
 * - assign SF users to the default roles (Developer or Reader) (the can also be created)
 * - delete SF users that are not needed anymore
 * - **ADVANCED** assign SF users to any other existing role (role and users need to exist)
 */

{% set users_dict_yaml -%}

## ** CORE Setup **
## This is the CORE part of the setup, where you can configure the users 
## to be created (if you run the create_users macro) and asigned to the default roles (by running the refresh macro).
## You can configure only one user for the dbt_executor role (to create it run the create_dbt_executor_user... macro)
## and a list of user for the developers or readers roles.

dbt_executor: XXXXX_DBT_EXECUTOR

developers:
 - ROBERTO_ZAGNI_ADMIN          # high privilege user for interactive access (SF UI) and to run the "Snowflake Admin" project & scripts
 - ROBERTO_ZAGNI_DEVELOPER      # limited privilege user for normal dbt project development tasks
 - USER@COMPANY.COM
 - NAME.SURNAME@COMPANY.COM


readers:
  - POWERBI_READER

#users_to_delete:                # to actually delete uncomment and run the drop_users macro
#  - SOME_USER_NAME_TO_DROP
#  - OTHER_USER_NAME_TO_DROP


## ** ADVANCED Setup **
## This is the ADVANCED part of the user setup, where you can leverage the existing scripts to assign existing users to existing roles.
## You should explicitly create the roles in some other script using the create_role macro, as we already did in the project_initial_setup script.
## We suggest making a new script file named like new_project_roles.sql with one macro for each new role you want to create.
## Once you created the role you can configure here to which users to asisgn the role.
## Here you do not create new users, for that you use the developers or readers lists or you create them explicitly in another macro.

#SOME_ROLE:                      # An EXISTING role to be assigned to the list of users under it
# - ROBERTO_ZAGNI_DEVELOPER      # An EXISTING user to which the role will be assigned 

#AI_TEAM_ROLE:
# - AI_GUY@COMPANY.COM
# - AI_TEAM_SERVICE_USER

#FINANCE_TEAM_ROLE:
# - FINANCE_GUY@COMPANY.COM

{%- endset %}
{% do return(fromyaml(users_dict_yaml)) %}
{%- endmacro %}

/* == Macro to run the user UPDATE as a dbt run-operation == */
{% macro refresh_user_roles___XXXXX_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}

    {%- set prj_name = var('project_short_name', 'XXXXX') -%}
    {% set useradmin_role = var('useradmin_role', 'USERADMIN') %}

    {% do log("Refreshing user roles for "~prj_name~" project ", info=True) %}
    {% do run_query(
        sf_project_admin.refresh_user_roles(
            prj_name,
            get_XXXXX_user_dictionary(),
            useradmin_role
        )
    ) %}
    {% do log("Refreshed user roles for "~prj_name~" project ", info=True) %}

{% endif %}{%- endmacro %}

/* == Macro to run the dbt user creation as a dbt run-operation IF you do not run the full user creation == */
{% macro create_dbt_executor_user___XXXXX_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}

    {%- set prj_name = var('project_short_name', 'XXXXX') -%}
    {%- set useradmin_role = var('useradmin_role', 'USERADMIN') -%}

    {% do log("Refreshing user roles for "~prj_name~" project ", info=True) %}
    /** CREATE dbt Executor User */
    {% do run_query(
        sf_project_admin.create_dbt_executor_user(
            prj_name = prj_name,
            user_name = get_XXXXX_user_dictionary().dbt_executor,
            useradmin_role = useradmin_role
        )
    ) %}

{% do log("Refreshed user roles for "~prj_name~" project ", info=True) %}
{% endif %}{%- endmacro %}

/* == Macro to run the user CREATION as a dbt run-operation == */
{% macro create_users___XXXXX_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}

    {%- set prj_name = var('project_short_name', 'XXXXX') -%}
    {%- set useradmin_role = var('useradmin_role', 'USERADMIN') -%}

    /* Create users listed in the YAML definition */
    {% do log("Creating users for "~prj_name~" project ", info=True) %}
    {% do run_query(
        sf_project_admin.create_users_from_dictionary(
            prj_name, get_XXXXX_user_dictionary(), useradmin_role
        )
    ) %}
    {% do log("Created users for "~prj_name~" project ", info=True) %}

{% endif %}{%- endmacro %}

/* == Macro to run the user CREATION as a dbt run-operation == */
{% macro drop_users___XXXXX_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}

    {%- set useradmin_role = var('useradmin_role', 'USERADMIN') -%}

    /* Drop users listed for deletion  */
    {% do log("Dropping users marked for deletion for "~prj_name~" project ", info=True) %}
    {% do run_query(
        sf_project_admin.drop_users(get_XXXXX_user_dictionary().users_to_delete, useradmin_role)
    ) %}
    {% do log("Dropped users marked for deletion for "~prj_name~" project ", info=True) %}

{% endif %}{%- endmacro %}
