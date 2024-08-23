{% macro setup_users(
    prj_name, 
    users_dict, 
    useradmin_role = none,
    default_wh_name = none,
    default_db_name = none
) -%}
    /** Set defaults if params not passed */ 
    {% set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}
    {% set default_wh_name = default_wh_name or sf_project_admin.get_warehouse_name(prj_name) %}
    {% set default_db_name = default_db_name or sf_project_admin.get_db_name(prj_name, var('dev_env_names', ['DEV'])[0]) %}
        
    /** Collect special role names based on the project name */ 
    {%- set (executor_role_name, developer_role_name, reader_role_name) 
                = sf_project_admin.get_default_org_role_names(prj_name) %}

    /** CREATE USERS and ASSIGN them the ORG ROLES */ 
    USE ROLE {{useradmin_role}};

    {{ sf_project_admin.setup_dbt_user(
        dbt_executor_user_name = users_dict.dbt_executor,
        initial_dbt_executor_pw = var('initial_dbt_executor_pw', 'Ch4ng3.M3'),
        dbt_executor_role_name = executor_role_name,
        default_wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name = none),
        default_db_name = sf_project_admin.get_db_name(prj_name, var('dev_env_names')[0])
    ) }}

    {{ sf_project_admin.setup_users_for_role(developer_role_name, users_dict.developers) }}

    {{ sf_project_admin.setup_users_for_role(reader_role_name, users_dict.readers) }}

    {{ sf_project_admin.drop_users(users_dict.users_to_delete) }}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_dbt_user(
    dbt_executor_user_name,
    initial_dbt_executor_pw,
    dbt_executor_role_name,
    default_wh_name,
    default_db_name
) -%}

  {% if not dbt_executor_user_name %}{% do return('') %}{% endif %}

    {{ sf_project_admin.create_user(
        user_name = dbt_executor_user_name,
        default_role_name = dbt_executor_role_name,
        initial_pw = initial_dbt_executor_pw,
        default_wh_name = default_wh_name,
        default_db_name = default_db_name,
        useradmin_role = var('useradmin_role', 'USERADMIN')
    ) }}

  GRANT ROLE {{executor_role_name}} TO USER  "{{dbt_executor}}" ; 

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_users_for_role(role_name, user_list) -%}
  {% if not role_name or user_list|length == 0  %}{% do return('') %}{% endif %}

  {%- for user_name in user_list %}
      GRANT ROLE {{role_name}} TO USER "{{user_name}}";
  {%- endfor %}
{%- endmacro %}

------------------------------------------------------------------------------------

{% macro drop_users(users_to_delete) -%}
  {% if not users_to_delete %}{% do return('') %}{% endif %}

  {%- for user_name in users_to_delete -%}
  
    DROP USER IF EXISTS "{{user_name}}";

  {%- endfor -%}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro setup_other_users(prj_name, users_dict) -%}
    {%- for role in users_dict -%}
        {% if role not in ['dbt_executor', 'developers', 'readers', 'users_to_delete'] %}
            {{ setup_users_for_role(role, users_dict[role]) }}
        {% endif %}
    {%- endfor %}
{%- endmacro %}

