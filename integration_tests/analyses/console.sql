    {# --- MANDATORY CONFIGS --- #}
    {%- set prj_name = 'SAMPLE' -%}
    {%- set environments = ['XDEV', 'XQA', 'XPROD'] -%}

    {# --- OPTIONAL CONFIGS --- #}
    {%- set owner_role = 'SOME_OWNER' -%}
    {%- set creator_role = 'SOME_CREATOR' -%}
    {%- set useradmin_role = 'SOME_USERADMIN' -%}

    {#{ sf_project_admin.create_default_org_roles(prj_name, owner_role, useradmin_role) }#}
    {{ sf_project_admin.grant_to_default_org_roles(prj_name, environments, useradmin_role) }}