WITH
use_case_01 as (
    {% set (prj_name, environments, owner_role, useradmin_role)
          =('SAMPLE', ['XDEV', 'XQA', 'XPROD'], 'SOME_OWNER', 'SOME_USERADMIN') %}
    SELECT 
    '{{prj_name}}' as prj_name, 
    '{{environments | replace("'", "\\'") }}' as environments,     
    '{{owner_role}}' as owner_role,     
    '{{useradmin_role}}' as useradmin_role,     
    '{{ sf_project_admin.grant_to_default_org_roles(prj_name, environments, useradmin_role) |e }}' as result,

    'GRANT ROLE SAMPLE_XDEV_RW TO ROLE SAMPLE_DBT_EXECUTOR_ROLE;' as validate_dev_RW_to_executor,
    'GRANT ROLE SAMPLE_XQA_RW TO ROLE SAMPLE_DBT_EXECUTOR_ROLE;' as validate_qa_RW_to_executor,
    'GRANT ROLE SAMPLE_XPROD_RW TO ROLE SAMPLE_DBT_EXECUTOR_ROLE;' as validate_prod_RW_to_executor,

    'GRANT ROLE SAMPLE_XDEV_RW TO ROLE SAMPLE_DEVELOPER;' as validate_dev_RW_to_developer,
    'GRANT ROLE SAMPLE_XQA_RO TO ROLE SAMPLE_DEVELOPER;' as validate_qa_RO_to_developer,
    'GRANT ROLE SAMPLE_XQA_RO TO ROLE SAMPLE_DEVELOPER;' as validate_prod_RO_to_developer,

    'GRANT ROLE SAMPLE_XDEV_RO TO ROLE SAMPLE_READER;' as validate_dev_RO_to_reader,
    'GRANT ROLE SAMPLE_XQA_RO TO ROLE SAMPLE_READER;' as validate_qa_RO_to_reader,
    'GRANT ROLE SAMPLE_XQA_RO TO ROLE SAMPLE_READER;' as validate_prod_RO_to_reader,

    'USE ROLE SOME_USERADMIN;' as validate_useradmin_role
)

SELECT * FROM use_case_01
-- UNION
-- SELECT * FROM use_case_02
