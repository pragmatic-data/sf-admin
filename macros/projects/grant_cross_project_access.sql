{%- macro grant_cross_project_access__sql(config_dict, owner_role = none) -%}

{%- set owner_role = owner_role or var('owner_role', 'SYSADMIN') %}
USE ROLE {{owner_role}};

{%- for role_to_grant, prj_list in config_dict.items() %}
    -- Granting role {{ role_to_grant }} to RW roles of configured projects & environments

    {%- for prj_dict in prj_list %}
        {%- for prj, env_list in prj_dict.items() %}
            -- grant to RW roles in Project {{prj}} 

            {%- for env in env_list %}
                GRANT ROLE {{role_to_grant}} TO ROLE {{sf_project_admin.get_writer_name(prj, env)}};
            {%- endfor %}

        {% endfor %}
    {%- endfor %}
{% endfor %}

{%- endmacro %}
