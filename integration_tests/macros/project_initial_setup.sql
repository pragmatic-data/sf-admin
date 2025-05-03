{% macro run_create_sample_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}
    {% do log("Creating SAMPLE project ", info=True) %}
    {% do run_query(create_sample_project()) %}
    {% do log("Created SAMPLE project ", info=True) %}
{% endif %}{%- endmacro %}


{% macro create_sample_project() -%}

    {#---- CONFIGURATION is done through a few VARIABLES --- #}
    {#---- Local variables in this script take values from the variables defined in the dbt_project.yml file #}
    {#--   of your project if you define them, of the SF Admin package or the default value provided here. #}
    {#---- To redefine a variable in this script only, replace the var() call with the value you want, as a string #}
    {#---- If you want to define a value to be used across the full project, copy the variable from the SF Admin package #}
    {#--   into your project's dbt_project.yml file and enter your desired values there. No changes here. #}

    {#---- CONFIGS YOU MIGHT WANT TO CHANGE by changing the variables in the dbt_project.yml file #}
    {%- set prj_name = var('project_short_name') -%}
    {%- set environments = var('environments') -%}
    {%- set owner_role = var('owner_role') -%}   {# Default is 'SYSADMIN' set in dbt_project.yml file #}

    {#---- CONFIGS YOU MIGHT WANT TO LIVE WITH THE DEFAULTS #}
    {%- set creator_role = var('creator_role', 'SYSADMIN') -%}
    {%- set useradmin_role = var('useradmin_role', 'USERADMIN') -%}

    {#---- IF you want to use an existing role, like SYSADMIN, remove the following call to create_role() --- #}
    {#---- IF the project specific owner role that you want to use does not already exist, create it here --- #}
    {#--   with the provided create_role() call and select the parent role to own it. SYSADMIN is a good choice #}
        {{ sf_project_admin.create_role(
                owner_role,
                comment = 'Sysadmin like role that will own the resources of the '~prj_name~' project.',
                parent_role = 'SYSADMIN',
                useradmin_role = useradmin_role
        ) }}

    /* == Create ONE WAREHOUSE for ALL envs => pass NO env name or pass/set single_WH to true == */
    {{- sf_project_admin.create_warehouse(prj_name, single_WH = true) }}
    /* == Create ONE WAREHOUSE for EACH env => put in ENV loop + pass the env name == */
    {#{ sf_project_admin.create_warehouse(prj_name, env_name, owner_role, creator_role, single_WH = false) }#}

    /* == Create ALL environments, one at a time == */
    {%- for env_name in environments %}
        {#---- IF the development user running this script cannot impersonate the SECURITYADMIN role,                   #}
        {#--   set it to null here, so that future grants are not assigned to the reader roles.                         #}
        {#--   You will then need to grant the future grants manually, or re-running this with SECURITYADMIN set        #}
        {#--   or you can use the dbt grant feature to assign the generated DB objects to the roles when you build them #}
        {{ sf_project_admin.create_environment(
            prj_name = prj_name,
            env_name = env_name,
            owner_role = owner_role,
            creator_role = creator_role,
            useradmin_role = useradmin_role,
            future_grants_role = 'SECURITYADMIN',
            single_WH = true
        ) }}
        {#---- IF you want to give access to a shared Snowflake warehouse to the Writer roles (to save credits) #}
        {#--   you can use the grant_shared_wh_to_writer_role() macro. #}
        {#--   Provide the name of the owner role of the shared warehouse or of a role which can grant usage on the WH. #}
        {#--   It might not be this project's owner role. #}
        {#--   While you can set the name of the shared WH here, it is better done in the dbt_project file with shared_dev_wh. #}
        {#{ sf_project_admin.grant_shared_wh_to_writer_role(
            prj_name = prj_name,
            env_name = env_name,
            owner_role = 'SYSADMIN',
            shared_dev_wh = none
        ) }#}
    {%- endfor %}


    /* == Setup ORGANIZATIONAL ROLES == */
    {#-- The setup_default_org_roles() macro will create and configure the executor, developer and reader roles #}
    {#-- for the project, assigning each role the right combination of RW and RO roles for each environment. #}
    {{ sf_project_admin.setup_default_org_roles(
        prj_name = prj_name,
        environments = environments,
        owner_role = owner_role,
        useradmin_role = useradmin_role
    ) }}

    /* == TO Create and Setup USERS => go to sample_prj__manage_users and run refresh_user_roles___XXXX_project()  == */

{%- endmacro %}