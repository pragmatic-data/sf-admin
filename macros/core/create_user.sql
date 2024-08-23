{% macro create_user(
    user_name,
    default_role_name,
    initial_pw = none,
    default_wh_name = none,
    default_db_name = none,
    useradmin_role = var('useradmin_role', 'USERADMIN')
) -%}

    {% set initial_pw = initial_pw or var('initial_pw', 'Ch4ng3.ME') %}

    {% if not user_name or not default_role_name %}
        {% do log("User name or default role missing, no user created!", info=True) %}
        {% do return('') %}
    {% endif %}

    USE ROLE {{useradmin_role}};

    CREATE USER IF NOT EXISTS "{{user_name}}" 
        COMMENT = 'User created by a DBT project'
        PASSWORD = '{{ initial_pw }}'
        MUST_CHANGE_PASSWORD = TRUE 
        DEFAULT_ROLE = '{{default_role_name}}'
        {% if default_wh_name %}DEFAULT_WAREHOUSE = '{{default_wh_name}}'{% endif %}
        {% if default_db_name %}DEFAULT_NAMESPACE = '{{default_db_name}}'{% endif %}
    ;

    GRANT ROLE {{executor_role_name}} TO USER  "{{dbt_executor}}" ; 

{%- endmacro %}