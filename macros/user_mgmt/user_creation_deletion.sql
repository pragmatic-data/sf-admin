{% macro create_users_from_dictionary(
    prj_name, 
    users_dict, 
    useradmin_role = none,
    default_wh_name = none,
    default_db_name = none
) -%}
    {% if not prj_name or not users_dict %}{% do return('') %}{% endif %}

    /** Set defaults if params not passed */ 
    {% set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}
    {% set initial_pw = var('initial_dbt_executor_pw', 'Ch4ng3.M3') %}
    {% set default_wh_name = default_wh_name or sf_project_admin.get_warehouse_name(prj_name) %}
    {% set default_db_name = default_db_name or sf_project_admin.get_db_name(prj_name, var('dev_env_names', ['DEV'])[0]) %}
        
    /** Collect special role names based on the project name */ 
    {%- set (executor_role_name, developer_role_name, reader_role_name) 
                = sf_project_admin.get_default_org_role_names(prj_name) %}

    /** CREATE dbt Executor User */ 
    {{ sf_project_admin.create_dbt_executor_user(
            prj_name = prj_name, 
            user_name = users_dict.dbt_executor,
            default_wh_name = default_wh_name,
            default_db_name = default_db_name,
            useradmin_role = useradmin_role
    ) }}

    /** CREATE Developer Users */ 
    {{ sf_project_admin.create_users_for_role(
        role_name = developer_role_name,
        user_list = users_dict.developers,
        initial_pw = initial_pw,
        default_wh_name = default_wh_name,
        default_db_name = default_db_name,
        useradmin_role = useradmin_role
    ) }}

    /** CREATE Reader Users */ 
    {{ sf_project_admin.create_users_for_role(
        role_name = reader_role_name,
        user_list = users_dict.readers,
        initial_pw = initial_pw,
        default_wh_name = default_wh_name,
        default_db_name = default_db_name,
        useradmin_role = useradmin_role
    ) }}

    /** CREATE Users for the other roles */ 
    {%- for role in users_dict -%}
        {% if role not in ['dbt_executor', 'developers', 'readers', 'users_to_delete'] %}
            {{ sf_project_admin.create_users_for_role(
                role_name = role,
                user_list = users_dict[role],
                initial_pw = initial_pw,
                default_wh_name = default_wh_name,
                default_db_name = default_db_name,
                useradmin_role = useradmin_role
            ) }}
        {% endif %}
    {%- endfor %}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro create_users_for_role(
    role_name, user_list, 
    initial_pw=none, default_wh_name = none, default_db_name = none, useradmin_role = none
) %}
    {% if not role_name or not user_list %}{% do return('') %}{% endif %}

    {% for user_name in user_list %}
        {{ sf_project_admin.create_user(
            user_name = user_name,
            default_role_name = role_name,
            initial_pw = initial_pw,
            default_wh_name = default_wh_name,
            default_db_name = default_db_name,
            useradmin_role = useradmin_role
        ) }}
    {% endfor %}

{% endmacro %}

------------------------------------------------------------------------------------

{% macro drop_users(
    users_to_delete,
    useradmin_role = none
) -%}
    {% if not users_to_delete %}{% do return('') %}{% endif %}

    {%- for user_name in users_to_delete -%}
        {{ sf_project_admin.drop_user(user_name, useradmin_role) }}
    {%- endfor -%}

{%- endmacro %}

------------------------------------------------------------------------------------

{% macro create_dbt_executor_user(
        prj_name,
        user_name,
        default_wh_name = sf_project_admin.get_warehouse_name(prj_name),
        default_db_name = sf_project_admin.get_db_name(prj_name, var('dev_env_names', ['DEV'])[0]),
        useradmin_role = none
) -%}
    {% if not prj_name or not user_name %}{% do return('') %}{% endif %}

    {% set initial_pw = var('initial_dbt_executor_pw', 'Ch4ng3.M3') %}
    {% set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}
    {%- set (executor_role_name, developer_role_name, reader_role_name) 
                = sf_project_admin.get_default_org_role_names(prj_name) %}

    /** CREATE dbt Executor User */ 
    {{ sf_project_admin.create_user(
        user_name = user_name,
        default_role_name = executor_role_name,
        initial_pw = initial_pw,
        default_wh_name = default_wh_name,
        default_db_name = default_db_name,
        useradmin_role = useradmin_role
    ) }}
{%- endmacro %}
