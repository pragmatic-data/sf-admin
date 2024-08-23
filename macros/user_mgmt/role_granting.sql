{% macro refresh_user_roles(
    prj_name, 
    users_dict, 
    useradmin_role = none
 ) -%}
    /** Set defaults if params not passed */ 
    {% set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}
        
    /** Collect special role names based on the project name */ 
    {%- set (executor_role_name, developer_role_name, reader_role_name) 
                = sf_project_admin.get_default_org_role_names(prj_name) %}

    /** ASSIGN the ORG ROLES to the configured USERS **/ 
    USE ROLE {{useradmin_role}};

    {{ sf_project_admin.grant_role_to_user(
        role_name = executor_role_name,
        user_name = users_dict.dbt_executor
    ) }}

    {{ sf_project_admin.grant_role_to_users(
        role_name = developer_role_name, 
        user_list = users_dict.developers
    ) }}

    {{ sf_project_admin.grant_role_to_users(
        role_name = reader_role_name, 
        user_list = users_dict.readers
    ) }}

    /** ASSIGN all other ROLES to the listed USERS **/ 
    {{ sf_project_admin.grant_other_roles(prj_name, users_dict) }}

    {#{ sf_project_admin.drop_users(users_dict.users_to_delete) }#}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro grant_role_to_users(role_name, user_list) -%}
  {% if not role_name or user_list|length == 0  %}{% do return('') %}{% endif %}
  {%- for user_name in user_list %}
      {{ sf_project_admin.grant_role_to_user(role_name,user_name) }}
  {%- endfor %}
{%- endmacro %}

------------------------------------------------------------------------------------

{% macro grant_role_to_user(role_name,user_name) -%}

    GRANT ROLE {{role_name}} TO USER "{{user_name}}"; 

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro grant_other_roles(prj_name, users_dict) -%}
    {%- for role in users_dict -%}
        {% if role not in ['dbt_executor', 'developers', 'readers', 'users_to_delete'] %}
            {{ sf_project_admin.grant_role_to_users(role, users_dict[role]) }}
        {% endif %}
    {%- endfor %}
{%- endmacro %}

