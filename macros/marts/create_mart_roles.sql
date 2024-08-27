/* ** SAMPLE Dictionary **
XXXXX_ROLE:                                    # Role to be created (to be granted RO access to the listed resources)
    - XXX_SCHEMA_NAME: ['QA', 'PROD']          #   - Schema name to grant access to: [list of envs to grant access to]
*/
{% macro create_mart_roles__sql(
    role_dict,
    owner_role,
    useradmin_role = none
) %}
{%- set owner_role = owner_role or var('owner_role', 'SYSADMIN') %}
{%- set useradmin_role = useradmin_role or var('useradmin_role', 'USERADMIN') %}

{%- for role_to_create in role_dict %}
    {{ sf_project_admin.create_role( 
            role_to_create,
            'Role created by SF Project Admin tool to access specific data marts.',
            owner_role,
            useradmin_role
    ) }}
{%- endfor %}
{% endmacro %}