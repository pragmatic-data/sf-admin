{% macro create_environment( prj_name, sysadmin_root_role, env_name, single_WH = true ) -%}
  {%- do log("*+  Creating environment for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}

  {{ sf_project_admin.create_env_database(prj_name, sysadmin_root_role, env_name ) }}

  {{ sf_project_admin.create_functional_roles(prj_name, sysadmin_root_role, env_name) }}

  {{ sf_project_admin.grants_to_writer_role(prj_name, env_name, single_WH) }}

  {% if env_name != 'DEV' %}
      {{- sf_project_admin.grants_to_reader_role(prj_name, env_name, single_WH) }}
  {% endif -%}

  {%- do log("*-  DONE with environment creation for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}
{%- endmacro %}

----------------------------------------

{% macro get_db_name(prj_name, env_name) -%}
{% do return(prj_name ~ '_' ~ env_name) %}
{%- endmacro %}

----------------------------------------

{% macro create_env_database(prj_name, sysadmin_root_role, env_name ) -%}
  {%- do log("**  Creating database for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}

  /* ---- create_env_database for {{env_name}} ---- */
  USE ROLE SYSADMIN;

  {%- set db_name = sf_project_admin.get_db_name(prj_name, env_name) %}
  
  /** 1 ** Create env DB */
  CREATE DATABASE IF NOT EXISTS {{db_name}};
  {%- do log("**  Created database " ~ db_name ~ " for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}

  /** 2 ** transfer ownership of DB to root SysAdmin role */
  GRANT OWNERSHIP ON DATABASE {{db_name}} TO ROLE {{sysadmin_root_role}};
  {%- do log("**  Assigned ownership of database " ~ db_name ~ " to role " ~ sysadmin_root_role , info=True) %}

{%- endmacro %}

----------------------------------------

{% macro create_functional_roles(prj_name, sysadmin_root_role, env_name ) -%}
  {%- do log("**  Creating functional roles for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}

  /* ---- create_functional_roles for {{env_name}} ---- */
  USE ROLE USERADMIN;

  /** 1 ** Create the WRITER role (DB wide) */
  {%- set writer_role_name = sf_project_admin.get_writer_name(prj_name, env_name) %}

  {{ sf_project_admin.create_role( writer_role_name, 'Functional role to provide Read/Write access to the '~env_name~' db of the '~prj_name~' project' ) }}

    /** 1.1 Add WRITER role under root sysadmin */
    GRANT ROLE {{writer_role_name}} TO ROLE {{sysadmin_root_role}};

  {%- do log("**  Created and configured WRITER role for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}


    /** 2 ** Create the READER role (DB wide) */
    {%- set reader_role_name = sf_project_admin.get_reader_name(prj_name, env_name) %}

    {{ sf_project_admin.create_role( reader_role_name, 'Functional role to provide Read Only access to the '~env_name~' db of the '~prj_name~' project' ) }}

    {%- do log("**  Created READER role for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) %}

{%- do log("**  Created functional roles for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}
{%- endmacro %}

----------------------------------------

{% macro grants_to_writer_role(prj_name, env_name, single_WH ) -%}
  {%- do log("**  Granting to writer role for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}

  /* ---- grants_to_writer_role for {{env_name}} ---- */

  {%- set writer_role_name = sf_project_admin.get_writer_name(prj_name, env_name) %}
  {%- set db_name = sf_project_admin.get_db_name(prj_name, env_name) %}
  {%- set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name, single_WH) %}

  USE ROLE SYSADMIN;

  GRANT USAGE ON WAREHOUSE {{wh_name}}                              TO ROLE {{writer_role_name}};
  GRANT USAGE ON WAREHOUSE {{ var('shared_dev_wh', 'SHARED_DEV_WH') }}  TO ROLE {{writer_role_name}};

  GRANT USAGE ON DATABASE {{db_name}}                     TO ROLE {{writer_role_name}};
  
  GRANT OWNERSHIP ON ALL SCHEMAS IN DATABASE {{db_name}}  TO ROLE {{writer_role_name}};
  GRANT CREATE SCHEMA ON DATABASE {{db_name}}             TO ROLE {{writer_role_name}};

  {%- do log("**  Granted to writer role for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}
{%- endmacro %}

----------------------------------------

{% macro grants_to_reader_role(prj_name, env_name, single_WH ) -%}
  {%- do log("**  Granting to reader role for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}

  /* ---- grants_to_reader_role for {{env_name}} ---- */

  {%- set reader_role_name = sf_project_admin.get_reader_name(prj_name, env_name) %}
  {%- set db_name = sf_project_admin.get_db_name(prj_name, env_name) -%}
  {%- set wh_name = sf_project_admin.get_warehouse_name(prj_name, env_name, single_WH) %}

  USE ROLE SYSADMIN;

  GRANT USAGE ON WAREHOUSE {{wh_name}}                  TO ROLE {{reader_role_name}};

  GRANT USAGE ON DATABASE {{db_name}}                   TO ROLE {{reader_role_name}};

  GRANT USAGE ON ALL SCHEMAS IN DATABASE {{db_name}}    TO ROLE {{reader_role_name}};
  GRANT USAGE ON FUTURE SCHEMAS IN DATABASE {{db_name}} TO ROLE {{reader_role_name}};

  GRANT SELECT ON ALL TABLES IN DATABASE {{db_name}}    TO ROLE {{reader_role_name}};
  GRANT SELECT ON FUTURE TABLES IN DATABASE {{db_name}} TO ROLE {{reader_role_name}};

  GRANT SELECT ON ALL VIEWS IN DATABASE {{db_name}}     TO ROLE {{reader_role_name}};
  GRANT SELECT ON FUTURE VIEWS IN DATABASE {{db_name}}  TO ROLE {{reader_role_name}};

  {%- do log("**  Granted to reader role for project " ~ prj_name ~ ", environment = " ~ env_name, info=True) -%}
{%- endmacro %}
