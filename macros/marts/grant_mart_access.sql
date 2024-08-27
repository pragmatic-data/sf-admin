/* ** SAMPLE Dictionary **
XXXXX_ROLE:                                    # Role to be granted RO access to the listed resources:
    - XXX_SCHEMA_NAME: ['QA', 'PROD']          #   - Schema name to grant access to: [list of envs to grant access to]
*/

{% macro grant_mart_access__sql(
    prj_name,
    role_dict,
    owner_role, 
    future_grants_role = var('future_grants_role', 'SECURITYADMIN'), 
    single_WH = none
) %}
{%- set owner_role = owner_role or var('owner_role', 'SYSADMIN') %}
{%- set single_WH = single_WH or var('single_WH', false) %}


{%- for role_to_grant in role_dict -%}

    {%- set schema_list = role_dict[role_to_grant] %}
    {%- for schema_dict in schema_list %}

        {%- for schema_to_access in schema_dict %}
            {%- set env_list = schema_dict[schema_to_access] %}
            {%- for env in env_list %}

{%- set env_wh = sf_project_admin.get_warehouse_name(prj_name, env_name = env, single_WH = single_WH) %}
{%- set env_db = sf_project_admin.get_db_name(prj_name, env_name = env) %}
{%- set reader_role = sf_project_admin.get_reader_name(prj_name, env_name = env) %}

USE ROLE {{owner_role}};

GRANT USAGE ON WAREHOUSE {{env_wh}} TO ROLE {{role_to_grant}};
GRANT USAGE ON DATABASE {{env_db}} TO ROLE {{role_to_grant}};

GRANT USAGE ON SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{role_to_grant}};
GRANT SELECT ON ALL TABLES IN SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{role_to_grant}};
GRANT SELECT ON ALL VIEWS IN SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{role_to_grant}};

{% if future_grants_role %}        
    USE ROLE {{future_grants_role}};

    GRANT SELECT ON FUTURE TABLES IN SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{role_to_grant}};
    GRANT SELECT ON FUTURE VIEWS IN SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{role_to_grant}};

    -- Move the future grant to schema level for RO user, as DB level future grants will not be applied anymore as schema level future grant exist
    GRANT SELECT ON FUTURE VIEWS IN SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{reader_role}};
    GRANT SELECT ON FUTURE TABLES IN SCHEMA {{env_db}}.{{schema_to_access}} TO ROLE {{reader_role}};
{% endif %}

-- *********************
            {%- endfor %}
        {% endfor %}
    {%- endfor %}
{% endfor %}

{%- endmacro %}
