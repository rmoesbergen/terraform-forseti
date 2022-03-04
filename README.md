
# Forseti installer terraform module

## How to use this module
1. Install terraform version 1.1.0 or newer
2. Install the google SDK (gcloud cli)
3. Create a google project that will hold the Forseti installation
4. Login to GCP/google-sdk with `gcloud auth application-default login`
5. Run this module as follows:

```bash
terraform init
terraform apply -var organization_id=<your org id> -var project_id=<project id> -var gsuite_admin_email=<someone@example.org>
```
You can get your organization ID by running:
```bash
gcloud organizations list
```

The module will create a service account called `cloud-foundation-forseti` and give it the required 
permissions to setup Forseti in the given organization and project. It will then use the Forseti terraform
module to install Forseti.

## Important settings

* `folder_id` (string, ""): ID of the GCP Folder where to install Forseti
* `config_validator_enabled` (bool, true): Controls if the Forseti config validator component should be installed. 
* `enable_policy_enforcer` (bool, true): Enables or disables the Policy Enforcer.
* `vpc_host_project_id` (string, ""): When using a shared VPC, specify the host project id here. IAM 
permissions will be configured on the host project for the forseti service account
* `server_type` (string, "n1-standard-8"): Type of compute instance that Forseti server will use
* `server_region` (string, "us-central1"): Region where the Forseti server will be installed
