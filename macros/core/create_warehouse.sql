
{% macro create_warehouse(prj_name 
                        , env_name = none
                        , owner_role = none
                        , creator_role = none
                        , single_WH = none
                          ) -%}
    {% set creator_role = creator_role or var('creator_role', 'SYSADMIN') %}
    {% set owner_role = owner_role or var('owner_role', 'SYSADMIN') %}
    {% set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name, single_WH) %}

    {%- do log("*+  Creating warehouse " ~ wh_name ~ " for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}

    USE ROLE {{creator_role}};  -- single_WH = {{single_WH}}

    /** 1 Create Warehouse */
    CREATE OR REPLACE WAREHOUSE {{wh_name}} WITH
        WAREHOUSE_SIZE = XSMALL 
        SCALING_POLICY = ECONOMY
        AUTO_SUSPEND = 120                -- 120 seconds = 2 minutes
        AUTO_RESUME = TRUE
        INITIALLY_SUSPENDED = TRUE
        COMMENT = 'Warehouse for {{prj_name}} project{{ ' and '~env_name~' environment.' if env_name else '.'}}'
    ;

    {%- do log("**  Created warehouse " ~ wh_name ~ " for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}

    /** 2 Assign Warehouse ownership to desired SysAdmin */
    GRANT OWNERSHIP ON WAREHOUSE {{wh_name}} TO ROLE {{owner_role}};

    {%- do log("**  Assigned ownerhip of warehouse " ~ wh_name ~ " to role " ~ owner_role, info=True) %}
    {%- do log("*-  DONE with warehouse creation for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}

{%- endmacro %}

