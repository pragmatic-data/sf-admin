{% macro run_create_sample_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}
    {% do log("Creating SAMPLE project ", info=True) %}
    {% do run_query(create_sample_project()) %}
    {% do log("Created SAMPLE project ", info=True) %}
{% endif %}{%- endmacro %}


{% macro create_sample_project() -%}

    {# --- MANDATORY CONFIGS --- #}
    {%- set prj_name = 'SAMPLE' -%}
    {%- set environments = ['XDEV', 'XQA', 'XPROD'] -%}

    {# --- OPTIONAL CONFIGS --- #}
    {%- set owner_role = 'SOME_OWNER' -%}
    {%- set creator_role = 'SOME_CREATOR' -%}

    /* == Create ONE WAREHOUSE for all envs => pass NO env name == */
    {#{ sf_project_admin.create_warehouse(prj_name, env_name, owner_role, creator_role) }#}
    {{- sf_project_admin.create_warehouse(prj_name) }}

    /* == Create ALL environments, one at a time == */
    {%- for env_name in environments %}
    {{ sf_project_admin.create_environment(prj_name, env_name, owner_role, creator_role, single_WH = true) }}
    {%- endfor %}


    /* == Setup ORGANIZATIONAL ROLES == */
    {{ sf_project_admin.create_default_org_roles(prj_name, environments) }}

    /* == TO Create and Setup USERS => go to sample__user_lists and run refresh_user_roles___sample_project()  == */

{%- endmacro %}