{% macro create_role( role_name
                    , comment = none
                    , parent_role = var('owner_role', 'SYSADMIN')
                    , useradmin_role = none
) -%}
    {% set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}

    {%- do log("*+  Creating role " ~ role_name, info=True) %}

    USE ROLE {{useradmin_role}};

    CREATE ROLE IF NOT EXISTS {{role_name}}
        COMMENT = '{{comment or "Role created by SF Project Admin"  }}';

    GRANT ROLE {{role_name}} TO ROLE {{parent_role}};
    {%- do log("*-  DONE with creating role " ~ role_name, info=True) -%}

{%- endmacro %}

