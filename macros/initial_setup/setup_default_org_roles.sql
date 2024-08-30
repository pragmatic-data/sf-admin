{% macro setup_default_org_roles(prj_name, environments, owner_role = none, useradmin_role = none) -%}

    {%- do log("*+  Creating default org roles for project " ~ prj_name ~ ", environments = " ~ environments, info=True) -%}
    {%- set owner_role = owner_role or var('owner_role', 'SYSADMIN') %}
    {%- set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}

    {{ sf_project_admin.create_default_org_roles(prj_name, owner_role, useradmin_role) }}

    {{ sf_project_admin.grant_to_default_org_roles(prj_name, environments, useradmin_role) }}

    {%- do log("*-  DONE with creating default org roles for project " ~ prj_name ~ ", environments = " ~ environments, info=True) -%}
{%- endmacro %}

-------------------------------------------------------------

{% macro create_default_org_roles(prj_name, owner_role, useradmin_role) -%}

    /** CREATE ORGANIZATIONAL ROLES */ 
    {% set (executor_role_name, developer_role_name, reader_role_name) = sf_project_admin.get_default_org_role_names(prj_name) %}

    {{ sf_project_admin.create_role( 
            executor_role_name,
            'Organizational role for the dbt user (RW access to all environments)',
            owner_role,
            useradmin_role
    ) }}
    {%- do log("**  Created DBT_EXECUTOR role for project " ~ prj_name , info=True) %}

    {{ sf_project_admin.create_role( 
            developer_role_name, 
            'Organizational role for the developers of the dbt project (RW access to DEV and RO to other environments)',
            owner_role,
            useradmin_role
    ) }}
    {%- do log("**  Created DEVELOPER role for project " ~ prj_name , info=True) %}

    {{ sf_project_admin.create_role( 
            reader_role_name, 
            'Organizational role for the readers of ALL the data from the dbt project (RO access to all layers of QA and PROD environments)',
            owner_role,
            useradmin_role
    ) }}
    {%- do log("**  Created READER role for project " ~ prj_name , info=True) %}

{%- endmacro %}

-------------------------------------------------------------

{% macro grant_to_default_org_roles(prj_name, environments, useradmin_role) -%}

    /** ASSIGN FUNCTIONAL ROLES to ORG ROLES */ 
    {%- set (executor_role_name, developer_role_name, reader_role_name) = sf_project_admin.get_default_org_role_names(prj_name) %}
    {%- set dev_env_names = var('dev_env_names', ['DEV']) %}

    USE ROLE {{useradmin_role}};

    /* DBT EXECUTOR */
    {%- for env_name in environments %}
        GRANT ROLE {{sf_project_admin.get_writer_name(prj_name, env_name)}} TO ROLE {{executor_role_name}};
    {%- endfor %}
    {%- do log("**  DONE functional role assigments for DBT_EXECUTOR role for project " ~ prj_name , info=True) %}


    /* DEVELOPER */
    {%- for env_name in environments %}
        {%- if env_name in dev_env_names %}
            GRANT ROLE {{sf_project_admin.get_writer_name(prj_name, env_name)}} TO ROLE {{developer_role_name}};
        {%- else %}
            GRANT ROLE {{sf_project_admin.get_reader_name(prj_name, env_name)}} TO ROLE {{developer_role_name}};
        {%- endif %}
    {%- endfor %}

    {%- do log("**  DONE functional role assigments for DEVELOPER role for project " ~ prj_name , info=True) %}


    /* READER */
    {%- for env_name in environments %}
        GRANT ROLE {{sf_project_admin.get_reader_name(prj_name, env_name)}} TO ROLE {{reader_role_name}};
    {%- endfor %}
    {%- do log("**  DONE functional role assigments for READER role for project " ~ prj_name , info=True) %}

{%- endmacro %}

