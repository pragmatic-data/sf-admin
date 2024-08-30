{% macro drop_user(
    user_name,
    useradmin_role = none
) -%}
    {% set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}

    USE ROLE {{useradmin_role}};

    DROP USER IF EXISTS "{{user_name}}";

{%- endmacro %}