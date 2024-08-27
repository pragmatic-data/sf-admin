WITH
use_case_01 as (
    {% set (prj_name,  env_name, owner_role, creator_role, single_WH)
          =('PROJECT', 'DEV', 'SOME_SYSADMIN', none, True) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{creator_role}}' as creator_role,     
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.create_warehouse(prj_name, env_name, single_WH, owner_role, creator_role) |e }}' as result,

    'CREATE OR REPLACE WAREHOUSE PROJECT_WH WITH' as validate_wh_name_creation,
    'GRANT OWNERSHIP ON WAREHOUSE PROJECT_WH TO' as validate_wh_name_grant,
    'TO ROLE SOME_SYSADMIN;' as validate_owner_role,
    'USE ROLE {{var('creator_role')}};' as validate_creator_role,
)
, use_case_01a as (
    {% set (prj_name,  env_name, owner_role, creator_role, single_WH)
          =('PROJECT', 'DEV', 'SOME_SYSADMIN', none, False) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{creator_role}}' as creator_role,     
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.create_warehouse(prj_name, env_name, single_WH, owner_role, creator_role) |e }}' as result,

    'CREATE OR REPLACE WAREHOUSE PROJECT_DEV_WH WITH' as validate_wh_name_creation,
    'GRANT OWNERSHIP ON WAREHOUSE PROJECT_DEV_WH TO' as validate_wh_name_grant,
    'TO ROLE SOME_SYSADMIN;' as validate_owner_role,
    'USE ROLE {{var('creator_role')}};' as validate_creator_role,
)
, use_case_02 as (
    {% set (prj_name,  env_name, owner_role, creator_role, single_WH)
          =('PROJECT', none, 'SOME_SYSADMIN', none, none) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{creator_role}}' as creator_role,     
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.create_warehouse(prj_name, env_name, single_WH, owner_role, creator_role) |e }}' as result,

    'CREATE OR REPLACE WAREHOUSE PROJECT_WH WITH' as validate_wh_name_creation,
    'GRANT OWNERSHIP ON WAREHOUSE PROJECT_WH TO' as validate_wh_name_grant,
    'TO ROLE SOME_SYSADMIN;' as validate_owner_role,
    'USE ROLE {{var('creator_role')}};' as validate_creator_role,
)
, use_case_03 as (
    {% set (prj_name,  env_name, owner_role, creator_role, single_WH)
          =('PROJECT', none, none, none, none) %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{env_name}}' as env_name, 
    '{{owner_role}}' as owner_role, 
    '{{creator_role}}' as creator_role,     
    '{{single_WH}}' as single_WH,     
    '{{ sf_project_admin.create_warehouse(prj_name, env_name, single_WH, owner_role, creator_role) |e }}' as result,

    'CREATE OR REPLACE WAREHOUSE PROJECT_WH WITH' as validate_wh_name_creation,
    'GRANT OWNERSHIP ON WAREHOUSE PROJECT_WH TO' as validate_wh_name_grant,
    'TO ROLE {{var('owner_role')}};' as validate_owner_role,
    'USE ROLE {{var('creator_role')}};' as validate_creator_role,
)
SELECT * FROM use_case_01
UNION
SELECT * FROM use_case_01a
UNION
SELECT * FROM use_case_02
UNION
SELECT * FROM use_case_03
