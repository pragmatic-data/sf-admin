WITH
use_case_01 as (
    {% set (role_name, comment, parent_role, useradmin_role)
          =('A_NEW_ROLE', 'A new role for some purpose', 'SOME_PARENT', 'SOME_USERADMIN') %}
    SELECT 
    '{{role_name}}' as role_name, 
    '{{comment}}' as comment, 
    '{{parent_role}}' as parent_role, 
    '{{useradmin_role}}' as useradmin_role,     
    '{{ sf_project_admin.create_role(role_name, comment, parent_role, useradmin_role) |e }}' as result,

    'CREATE ROLE IF NOT EXISTS A_NEW_ROLE' as validate_role_creation,
    'GRANT ROLE A_NEW_ROLE TO ROLE SOME_PARENT;' as validate_grant_to_parent_role,
    'USE ROLE SOME_USERADMIN;' as validate_useradmin_role
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
