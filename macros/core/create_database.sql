{% macro create_database( db_name
                        , comment = none
                        , owner_role = none
                        , creator_role = none
) -%}

    {% set creator_role = creator_role or var('creator_role', 'SYSADMIN') %}
    {% set owner_role = owner_role or var('owner_role', 'SYSADMIN') %}

    {%- do log("*+  Creating database " ~ db_name ~ ' ( '~ comment ~' )', info=True) %}
    /** 1 ** Create the DB with the specified creator role (having Create DB privilege) */
    USE ROLE {{creator_role}};

    CREATE DATABASE IF NOT EXISTS {{db_name}}
        COMMENT = '{{comment or "Database created by SF Project Admin"  }}';

    /** 2 ** transfer ownership of DB to the desired owner role */
    {%- do log("**  Assigned ownership of database " ~ db_name ~ " to role " ~ owner_role , info=True) %}
    GRANT OWNERSHIP ON DATABASE {{db_name}} TO ROLE {{owner_role}};
    GRANT ALL PRIVILEGES ON DATABASE {{db_name}} TO ROLE {{owner_role}};
    GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE {{db_name}} TO ROLE {{owner_role}};

    {%- do log("*-  DONE with creating database " ~ db_name, info=True) -%}

{%- endmacro %}

