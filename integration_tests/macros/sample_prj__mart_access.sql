{% macro get_XXXXX_mart_dictionary() -%}

/* *** Data mart setup config dictionary *** 
 * This file is used to:
 * - define the name of the ROLES to be created to provide access to specific data marts
 * - define what schemata are accessible (RO) to each role (and in which environments)
 * - 
 * NOTE: SF users can be assigned to these roles using the user dictionary created in the manage users macro.
 */

{% set mart_dict_yaml -%}
# -- SAMPLE Data MArt config Dictionary --

XXXXX_ROLE:                                    # Role to be granted:
    - XXX_SCHEMA_NAME: ['QA', 'PROD']          #   - Schema name: [list of envs to grant access to]

AI_TEAM_ROLE:
    - PRJ_MART_AI_TEAM: ['PROD']

FINANCE_TEAM_ROLE:
    - PRJ_MART_FINANCE: ['PROD']

{%- endset %}
{% do return(fromyaml(mart_dict_yaml)) %}
{%- endmacro %}

/* == Macro to run the user update as a dbt run-operation == */
{% macro config_mart_access___XXXXX_project() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}
    {% do log("Configuring data mart access for XXXXX project ", info=True) %}
    {%- set prj_name = 'SAMPLE' -%}
    {%- set owner_role = 'SOME_OWNER' -%}
    {%- set useradmin_role = 'SOME_USERADMIN' -%}
    
    {% do run_query( sf_project_admin.create_mart_roles__sql(get_XXXXX_mart_dictionary(), owner_role, useradmin_role) ) %}
    {% do run_query( sf_project_admin.grant_mart_access__sql( prj_name, get_XXXXX_mart_dictionary(), owner_role) ) %}

    {% do log("Refreshed user roles for XXXXX project ", info=True) %}
{% endif %}{%- endmacro %}
