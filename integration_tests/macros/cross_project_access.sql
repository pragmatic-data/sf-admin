{% macro get_cross_project_access_config() -%}
    {% set cross_project_access_config_yaml -%}
PRJ_AAA_PROD_RO:                                  # Role to be granted to RW roles of listed projects & envs:
    - PRJ_BBB: ['DEV', 'QA', 'PROD']              #   - Project_name: [list of envs to grant access to the role]
    - PRJ_CCC: ['DEV', 'QA', 'PROD']          

PRJ_BBB_PROD_RO:
    - PRJ_CCC: ['DEV', 'QA', 'PROD']

    {%- endset %}
    {% do return(fromyaml(cross_project_access_config_yaml)) %}
{%- endmacro %}

{% macro config_cross_project_access() -%}{% if execute and flags.WHICH in ('run', 'build', 'run-operation') %}
    {% do log("Configuring cross project access", info=True) %}
    {%- set owner_role = 'SOME_OWNER' -%}
    
    {% do run_query( 
        sf_project_admin.grant_cross_project_access__sql(
            get_cross_project_access_config(), 
            owner_role
    )) %}

    {% do log("Configured cross project access ", info=True) %}
{% endif %}{%- endmacro %}
