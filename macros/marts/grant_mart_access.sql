
{% macro grant_mart_access__sql(
        prj_name, 
        role_dict, 
        sysadmin_root_role = 'SYSADMIN'
    ) %}

USE ROLE {{sysadmin_root_role}};

{%- for role_to_grant in role_dict -%}

    {%- set schema_list = role_dict[role_to_grant] %}
    {%- for schema_dict in schema_list %}

        {%- for schema_to_access in schema_dict %}
            {%- set env_list = schema_dict[schema_to_access] %}
            {%- for env in env_list %}

GRANT USAGE ON WAREHOUSE {{prj_name}}_WH        TO ROLE {{role_to_grant}};  
GRANT USAGE ON DATABASE {{prj_name}}_{{env}}    TO ROLE {{role_to_grant}};

GRANT USAGE ON SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}}                     TO ROLE {{role_to_grant}};
GRANT SELECT ON ALL TABLES IN SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}}      TO ROLE {{role_to_grant}};
GRANT SELECT ON FUTURE TABLES IN SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}}   TO ROLE {{role_to_grant}};
GRANT SELECT ON ALL VIEWS IN SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}}       TO ROLE {{role_to_grant}};
GRANT SELECT ON FUTURE VIEWS IN SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}}    TO ROLE {{role_to_grant}};

-- Move the future grant to schema level for RO user, as DB level future grants will not be applied anymore as schema level future grant exist
GRANT SELECT ON FUTURE VIEWS IN SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}} TO ROLE {{prj_name}}_{{env}}_RO;
GRANT SELECT ON FUTURE TABLES IN SCHEMA {{prj_name}}_{{env}}.{{schema_to_access}} TO ROLE {{prj_name}}_{{env}}_RO;

-- *********************
            {%- endfor %}
        {% endfor %}
    {%- endfor %}
{% endfor %}

{%- endmacro %}
