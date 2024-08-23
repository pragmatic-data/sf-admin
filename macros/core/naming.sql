/*
 * This files collects all the macros that implement the naming convention 
 * used in the Pragmatic Data Platform (PDP)
 * - DB names
 * - Role names
 */


{% macro get_db_name(prj_name, env_name) -%}
{% do return(prj_name ~ '_' ~ env_name) %}
{%- endmacro %}

----------------------------------------

{% macro get_warehouse_name(prj_name, env_name = none, single_WH = false) -%}

  {%- if env_name and not single_WH -%} 
      {% do return(prj_name ~ '_' ~ env_name ~ '_WH') %}
  {%- else -%}
      {% do return(prj_name ~ '_WH') %}
  {%- endif -%}

{%- endmacro %}

----------------------------------------

{% macro get_role_name(prj_name, env_name, suffix) -%}
{% do return(prj_name ~ '_' ~ env_name ~ '_' ~ suffix) %}
{%- endmacro %}

{% macro get_writer_name(prj_name, env_name, suffix = 'RW') -%}
{% do return(sf_project_admin.get_role_name(prj_name, env_name, suffix)) %}
{%- endmacro %}

{% macro get_reader_name(prj_name, env_name, suffix = 'RO') -%}
{% do return(sf_project_admin.get_role_name(prj_name, env_name, suffix)) %}
{%- endmacro %}

-------------------------------------------------------------

{% macro get_default_org_role_names(prj_name) -%}

    {% set executor_role_name = prj_name ~ '_DBT_EXECUTOR_ROLE' %}
    {% set developer_role_name = prj_name ~ '_DEVELOPER' %}
    {% set reader_role_name = prj_name ~ '_READER' %}

    {% do return( (executor_role_name, developer_role_name, reader_role_name) ) %}

{%- endmacro %}
