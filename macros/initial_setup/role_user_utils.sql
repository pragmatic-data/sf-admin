{% macro create_role( role_name, comment = none
                    , parent_role = var('sysadmin_root_role', 'SYSADMIN')
                    , useradmin_role = var('useradmin_role', 'USERADMIN')
) -%}

  {%- do log("*+  Creating role " ~ role_name, info=True) -%}

  USE ROLE {{useradmin_role}};

  CREATE ROLE IF NOT EXISTS {{role_name}}
    COMMENT = '{{comment or "Role created by SF Project Admin"  }}';

  GRANT ROLE {{role_name}} TO ROLE {{parent_role}};
  {%- do log("*-  DONE with creating role " ~ role_name, info=True) -%}

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

