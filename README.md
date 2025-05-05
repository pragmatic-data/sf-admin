Welcome to the Snowflake Project Admin macro library!

### Snowflake Project Admin
This is a lightweight, opinionated package to quickly set up new dbt projects.

At the core it is built by a small set of macros that apply an opinionated 
role structure using a consistent naming strategy that makes easy to understand
what role does what inside one project and across projects.

## Installation
TL;DR add the following into your `packages.yml` or `dependencies.yml` file 
to pin to a specific version (suggested):
```
  # Snowflake Project Admin package
  - git: https://github.com/pragmatic-data/sf-admin.git
    revision: 0.1.0
```

or the following to stay on the latest, unexpected and unpredictable changes released to 'main' or any other branch you pick:
```
  # Pragmatic Data Platform package
  - git: https://github.com/pragmatic-data/sf-admin.git
    revision: main
    warn-unpinned: false
```

For the full explanation on how to install packages, please [read the dbt docs](https://docs.getdbt.com/docs/build/packages).

----
