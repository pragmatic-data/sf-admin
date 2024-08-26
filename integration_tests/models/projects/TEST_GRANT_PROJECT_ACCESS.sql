
{% set (cfg_dict, owner_role)
        =(get_cross_project_access_config(), 'SOME_OWNER') %}
WITH
use_case_01 as (
    SELECT     
    '{{cfg_dict | replace("'", "\\'") }}' as cfg_dict,     
    '{{owner_role}}' as owner_role, 
    '{{ sf_project_admin.grant_cross_project_access__sql(cfg_dict, owner_role) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,

    'GRANT ROLE PRJ_AAA_PROD_RO TO ROLE PRJ_BBB_DEV_RW;' as validate_dev,
    'GRANT ROLE PRJ_AAA_PROD_RO TO ROLE PRJ_BBB_QA_RW;' as validate_qa,
    'GRANT ROLE PRJ_AAA_PROD_RO TO ROLE PRJ_BBB_PROD_RW;' as validate_prod
)
, use_case_02 as (
    SELECT     
    '{{cfg_dict | replace("'", "\\'") }}' as cfg_dict,     
    '{{owner_role}}' as owner_role, 
    '{{ sf_project_admin.grant_cross_project_access__sql(cfg_dict, owner_role) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,

    'GRANT ROLE PRJ_AAA_PROD_RO TO ROLE PRJ_CCC_DEV_RW;' as validate_dev,
    'GRANT ROLE PRJ_AAA_PROD_RO TO ROLE PRJ_CCC_QA_RW;' as validate_qa,
    'GRANT ROLE PRJ_AAA_PROD_RO TO ROLE PRJ_CCC_PROD_RW;' as validate_prod
)
, use_case_03 as (
    SELECT     
    '{{cfg_dict | replace("'", "\\'") }}' as cfg_dict,     
    '{{owner_role}}' as owner_role, 
    '{{ sf_project_admin.grant_cross_project_access__sql(cfg_dict, owner_role) |e }}' as result,

    'USE ROLE SOME_OWNER;' as validate_owner_role,

    'GRANT ROLE PRJ_BBB_PROD_RO TO ROLE PRJ_CCC_DEV_RW;' as validate_dev,
    'GRANT ROLE PRJ_BBB_PROD_RO TO ROLE PRJ_CCC_QA_RW;' as validate_qa,
    'GRANT ROLE PRJ_BBB_PROD_RO TO ROLE PRJ_CCC_PROD_RW;' as validate_prod
)

SELECT * FROM use_case_01
UNION ALL
SELECT * FROM use_case_02
UNION ALL
SELECT * FROM use_case_03
