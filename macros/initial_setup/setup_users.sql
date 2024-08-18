{% macro setup_users(prj_name, users_dict) -%}

/** CREATE USERS and ASSIGN them the ORG ROLES */ 
  USE ROLE USERADMIN;

    {{ sf_project_admin.setup_dbt_user(prj_name, users_dict) }}

    {{ sf_project_admin.setup_developer_users(prj_name, users_dict) }}

    {{ sf_project_admin.setup_reader_users(prj_name, users_dict) }}

    {{ sf_project_admin.drop_users(users_dict) }}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_dbt_user(prj_name, users_dict) -%}

  {%- set (executor_role_name, developer_role_name, reader_role_name) = sf_project_admin.get_default_org_role_names(prj_name) %}
  {%- set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name = none) %}
  {%- set dev_db_name = sf_project_admin.get_db_name(prj_name, env_name = 'DEV') %}

  {% set dbt_executor = users_dict.dbt_executor %}
  {% if not dbt_executor %}{% do return('') %}{% endif %}

  CREATE USER IF NOT EXISTS  "{{dbt_executor}}" 
      COMMENT = 'User running DBT commands in the project'
      PASSWORD = '{{ env_var("DBT_EXECUTOR_PW") }}'
      MUST_CHANGE_PASSWORD = TRUE 
      DEFAULT_ROLE = '{{executor_role_name}}'
      DEFAULT_WAREHOUSE = '{{wh_name}}'
      DEFAULT_NAMESPACE = '{{dev_db_name}}'
  ;

  GRANT ROLE {{executor_role_name}} TO USER  "{{dbt_executor}}" ; 

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_developer_users(prj_name, users_dict) -%}

  {%- set (executor_role_name, developer_role_name, reader_role_name) = sf_project_admin.get_default_org_role_names(prj_name) %}
  {%- set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name = none) %}
  {%- set dev_db_name = sf_project_admin.get_db_name(prj_name, env_name = 'DEV') %}

  {% set developers = users_dict.developers %}
  {% if not developers %}{% do return('') %}{% endif %}

  {%- for user_name in developers %}
    GRANT ROLE {{developer_role_name}} TO USER "{{user_name}}";
  {%- endfor %}    
    ---------------------------------------------------------

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_reader_users(prj_name, users_dict) -%}

  {%- set (executor_role_name, developer_role_name, reader_role_name) = sf_project_admin.get_default_org_role_names(prj_name) %}
  {%- set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name = none) %}
  {%- set prod_db_name = sf_project_admin.get_db_name(prj_name, env_name = 'PROD') %}

  {% set readers = users_dict.readers %}
  {% if not readers %}{% do return('') %}{% endif %}

  {%- for user_name in readers %}
      GRANT ROLE {{reader_role_name}} TO USER "{{user_name}}";
  {%- endfor %}
{%- endmacro %}

------------------------------------------------------------------------------------

{% macro drop_users(users_dict) -%}

  {% set users_to_delete = users_dict.users_to_delete %}
  {% if not users_to_delete %}{% do return('') %}{% endif %}

  {%- for user_name in users_to_delete -%}
  
    DROP USER IF EXISTS "{{user_name}}";

  {%- endfor -%}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_other_users(prj_name, users_dict) -%}
    {%- for role in users_dict -%}
        {% if role not in ['dbt_executor', 'developers', 'readers', 'users_to_delete'] %}

        -- SET UP users for ROLE {{role}}
        {{ setup_users_for_role(role, users_dict) }}

        {% endif %}
    {%- endfor %}
{%- endmacro %}

{% macro setup_users_for_role(role, users_dict) -%}
    {%- set user_list = users_dict[role] %}
    {%- for user_name in user_list %}
        GRANT ROLE {{role}} TO USER "{{user_name}}";
    {%- endfor %}
{%- endmacro %}

