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

{% macro get_role_name(prj_name, env_name, suffix) -%}
{% do return(prj_name ~ '_' ~ env_name ~ '_' ~ suffix) %}
{%- endmacro %}

{% macro get_writer_name(prj_name, env_name, suffix = 'RW') -%}
{% do return(sf_project_admin.get_role_name(prj_name, env_name, suffix)) %}
{%- endmacro %}

{% macro get_reader_name(prj_name, env_name, suffix = 'RO') -%}
{% do return(sf_project_admin.get_role_name(prj_name, env_name, suffix)) %}
{%- endmacro %}

