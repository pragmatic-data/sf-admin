{% macro run_create_sample_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}
    {% do log("Creating SAMPLE project ", info=True) %}
    {% do run_query(create_sample_project()) %}
    {% do log("Created SAMPLE project ", info=True) %}
{% endif %}{%- endmacro %}


{% macro create_sample_project() -%}

    {# --- MANDATORY CONFIGS --- #}
    {%- set prj_name = 'SAMPLE' -%}
    {%- set environments = ['XDEV', 'XQA', 'XPROD'] -%}

    {# --- OPTIONAL CONFIGS to override variables from dbt_project.yml --- #}
    {%- set owner_role = 'SOME_OWNER' -%}
    {%- set creator_role = 'SOME_CREATOR' -%}
    {%- set useradmin_role = 'SOME_USERADMIN' -%}

    /* == Create ONE WAREHOUSE for ALL envs => pass NO env name or pass/set single_WH to true == */
    {{- sf_project_admin.create_warehouse(prj_name, single_WH = true) }}
    /* == Create ONE WAREHOUSE for EACH env => put in ENV loop + pass the env name == */
    {#{ sf_project_admin.create_warehouse(prj_name, env_name, owner_role, creator_role, single_WH = false) }#}

    /* == Create ALL environments, one at a time == */
    {%- for env_name in environments %}
        {{ sf_project_admin.create_environment(prj_name, env_name, owner_role, creator_role, useradmin_role, 'SECURITYADMIN', single_WH = true) }}
        {{ sf_project_admin.grant_shared_wh_to_writer_role(prj_name, env_name, owner_role = 'SYSADMIN' )}}
    {%- endfor %}


    /* == Setup ORGANIZATIONAL ROLES == */
    {{ sf_project_admin.create_default_org_roles(prj_name, environments, owner_role, useradmin_role) }}

    /* == TO Create and Setup USERS => go to sample_prj__manage_users and run refresh_user_roles___XXXX_project()  == */

{%- endmacro %}