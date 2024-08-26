WITH
use_case_01 as (
    {% set (mart_dict, owner_role, useradmin_role)
          =(get_XXXXX_mart_dictionary(), 'SOME_PARENT', 'SOME_USERADMIN') %}
    SELECT     
    '{{mart_dict | replace("'", "\\'") }}' as mart_dict,     
    '{{owner_role}}' as owner_role, 
    '{{useradmin_role}}' as useradmin_role,     
    '{{ sf_project_admin.create_mart_roles__sql(mart_dict, owner_role, useradmin_role) |e }}' as result,

    'USE ROLE SOME_USERADMIN;' as validate_useradmin_role,

    'CREATE ROLE IF NOT EXISTS XXXXX_ROLE' as validate_xxx_role_creation,
    'GRANT ROLE XXXXX_ROLE TO ROLE SOME_PARENT;' as validate_grant_xxx_to_owner_role,

    'CREATE ROLE IF NOT EXISTS AI_TEAM_ROLE' as validate_ai_role_creation,
    'GRANT ROLE AI_TEAM_ROLE TO ROLE SOME_PARENT;' as validate_grant_ai_to_owner_role,

    'CREATE ROLE IF NOT EXISTS FINANCE_TEAM_ROLE' as validate_fin_role_creation,
    'GRANT ROLE FINANCE_TEAM_ROLE TO ROLE SOME_PARENT;' as validate_grant_fin_to_owner_role
)

SELECT * FROM use_case_01
