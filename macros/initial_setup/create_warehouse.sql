
{% macro create_warehouse(prj_name, sysadmin_root_role , env_name = none) -%}

  USE ROLE SYSADMIN;

  {% set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name) %}

  {%- do log("*+  Creating warehouse " ~ wh_name ~ " for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}

  /** 1 Create Warehouse */
  CREATE OR REPLACE WAREHOUSE {{wh_name}} WITH
    WAREHOUSE_SIZE = XSMALL 
    SCALING_POLICY = ECONOMY
    AUTO_SUSPEND = 120                -- 120 seconds = 2 minutes
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for {{prj_name}} project.'
  ;
  {%- do log("**  Created warehouse " ~ wh_name ~ " for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}

  /** 2 Assign Warehouse ownership to desired SysAdmin */
  GRANT OWNERSHIP ON WAREHOUSE {{wh_name}} TO ROLE {{sysadmin_root_role}};
  {%- do log("**  Assigned ownerhip of warehouse " ~ wh_name ~ " to role " ~ sysadmin_root_role, info=True) %}

  {%- do log("*-  DONE with warehouse creation for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}
{%- endmacro %}



{% macro get_warehouse_name(prj_name, env_name = none, single_WH = false) -%}

  {%- if env_name and not single_WH -%} 
      {% do return(prj_name ~ '_' ~ env_name ~ '_WH') %}
  {%- else -%}
      {% do return(prj_name ~ '_WH') %}
  {%- endif -%}

{%- endmacro %}