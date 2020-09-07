# Concourse Management

A pipeline for managing Concourse teams and their authentication settings

## Required Parameters

```yaml
# The admin password for logging into fly
# this is a secret
admin_password:

# The admin username for logging into fly
# usually admin
concourse_admin_username:

# URL for reaching the Concourse (scheme included)
concourse_url:

# The environment being configured
# maps to files in this repo located at:
# - configs/((env))/**
# - vars/((env)).yml
env:
```

## Setting the Pipeline

```sh
fly -t target set-pipeline \
  --pipeline concourse-helm-mgmt \
  --config pipeline.yml \
  --var env=example \
  --load-vars-from vars/example.yml
```

## Team Configuration

In the directory `configs/((env))` you can create YAML files with names corresponding to the Concourse teams that you require. Look at the example env for more details.

```yaml
# cool-apps.yml
roles:
- name: owner
  local:
    users:
    - admin

- name: member
  local:
    users:
    - user

- name: viewer
  local:
    users:
    - devops
```

This configuration will, when applied, create/update a team called `cool-apps` with `admin` as the Owner, `user` as the Member, and `devops` as the Viewer. More information on these roles [can be found in the Concourse docs](https://concourse-ci.org/user-roles.html).

> Note: that the example config only uses basic auth users for simplicity. The best reference I've found for adding other auth types are the `team_config_*` fixtures [in the Concourse source code](https://github.com/concourse/concourse/tree/master/fly/integration/fixtures).

> Note: the main team is special in that any user with the Owner role on it has the ability to manage other teams as explained [in the docs](https://concourse-ci.org/main-team.html).

After running the pipeline with the example config, `fly teams --details` shows:

```sh
name/role         users                     groups
cool-apps/member  local:user                none
cool-apps/owner   local:admin               none
cool-apps/viewer  local:devops              none
devops/member     local:devops              none
devops/owner      local:admin               none
main/member       local:admin,local:devops  none
main/owner        local:admin               none
test/owner        local:admin               none
```
