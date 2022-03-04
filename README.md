
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

For a full list of variables, see:
[Variables](https://github.com/forseti-security/terraform-google-forseti/blob/master/variables.tf)

## Formatting, tflint and Checkov
The module has been formatted using 'terraform fmt', and passed through 'tflint' and 'checkov'.
Checkov was run using the following command:

```bash
checkov -d . --skip-path venv --download-external-modules terraform-google-modules/forseti/google:5.0.3
```

The failed checks are all prevent in the third party Forseti module, so they can't be fixed.
Here's the full checkov output, for reference:

```
     _               _              
   ___| |__   ___  ___| | _______   __
  / __| '_ \ / _ \/ __| |/ / _ \ \ / /
 | (__| | | |  __/ (__|   < (_) \ V / 
  \___|_| |_|\___|\___|_|\_\___/ \_/  
                                      
By bridgecrew.io | version: 2.0.917 

terraform scan results:

Passed checks: 80, Failed checks: 19, Skipped checks: 0

Check: CKV_GCP_45: "Ensure no roles that enable to impersonate and manage all service accounts are used at an organization level"
	PASSED for resource: google_organization_iam_member.forseti_org_iam
	File: /iam.tf:24-29
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_6
Check: CKV_GCP_47: "Ensure default service account is not used at an organization level"
	PASSED for resource: google_organization_iam_member.forseti_org_iam
	File: /iam.tf:24-29
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_8
Check: CKV_GCP_42: "Ensure that Service Account has no Admin privileges"
	PASSED for resource: google_project_iam_member.forseti_project_iam
	File: /iam.tf:31-36
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_4
Check: CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
	PASSED for resource: google_project_iam_member.forseti_project_iam
	File: /iam.tf:31-36
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_10
Check: CKV_GCP_46: "Ensure Default Service account is not used at a project level"
	PASSED for resource: google_project_iam_member.forseti_project_iam
	File: /iam.tf:31-36
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_7
Check: CKV_GCP_41: "Ensure that IAM users are not assigned the Service Account User or Service Account Token Creator roles at project level"
	PASSED for resource: google_project_iam_member.forseti_project_iam
	File: /iam.tf:31-36
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_3
Check: CKV_GCP_42: "Ensure that Service Account has no Admin privileges"
	PASSED for resource: google_project_iam_member.forseti_shared_vpc_project_iam
	File: /iam.tf:38-43
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_4
Check: CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
	PASSED for resource: google_project_iam_member.forseti_shared_vpc_project_iam
	File: /iam.tf:38-43
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_10
Check: CKV_GCP_46: "Ensure Default Service account is not used at a project level"
	PASSED for resource: google_project_iam_member.forseti_shared_vpc_project_iam
	File: /iam.tf:38-43
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_7
Check: CKV_GCP_41: "Ensure that IAM users are not assigned the Service Account User or Service Account Token Creator roles at project level"
	PASSED for resource: google_project_iam_member.forseti_shared_vpc_project_iam
	File: /iam.tf:38-43
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_3
Check: CKV_GCP_30: "Ensure that instances are not configured to use the default service account"
	PASSED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_1
Check: CKV_GCP_31: "Ensure that instances are not configured to use the default service account with full access to all Cloud APIs"
	PASSED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_2
Check: CKV_GCP_36: "Ensure that IP forwarding is not enabled on Instances"
	PASSED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_12
Check: CKV_GCP_34: "Ensure that no instance in the project overrides the project setting for enabling OSLogin(OSLogin needs to be enabled in project metadata for all instances)"
	PASSED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_10
Check: CKV_GCP_35: "Ensure 'Enable connecting to serial ports' is not enabled for VM Instance"
	PASSED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_11
Check: CKV_GCP_39: "Ensure Compute instances are launched with Shielded VM enabled"
	PASSED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_general_y
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-client-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:150-172
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-client-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:150-172
Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	PASSED for resource: google_compute_firewall.forseti-client-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:150-172
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-client-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:150-172
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-client-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:150-172
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:174-189
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:174-189
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:174-189
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:174-189
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:191-206
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:191-206
Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:191-206
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:191-206
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-client-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:191-206
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_42: "Ensure that Service Account has no Admin privileges"
	PASSED for resource: google_project_iam_member.client_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_iam/main.tf:42-47
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_4
Check: CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
	PASSED for resource: google_project_iam_member.client_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_iam/main.tf:42-47
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_10
Check: CKV_GCP_46: "Ensure Default Service account is not used at a project level"
	PASSED for resource: google_project_iam_member.client_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_iam/main.tf:42-47
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_7
Check: CKV_GCP_41: "Ensure that IAM users are not assigned the Service Account User or Service Account Token Creator roles at project level"
	PASSED for resource: google_project_iam_member.client_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_iam/main.tf:42-47
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_3
Check: CKV_GCP_50: "Ensure MySQL database 'local_infile' flag is set to 'off'"
	PASSED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_sql_1
Check: CKV_GCP_14: "Ensure all Cloud SQL database instance have backup configuration enabled"
	PASSED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_general_2
Check: CKV_GCP_11: "Ensure that Cloud SQL database Instances are not open to the world"
	PASSED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_4
Check: CKV_GCP_6: "Ensure all Cloud SQL database instance requires all incoming connections to use SSL"
	PASSED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_general_1
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-server-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:119-141
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-server-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:119-141
Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	PASSED for resource: google_compute_firewall.forseti-server-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:119-141
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-server-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:119-141
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-server-deny-all
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:119-141
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:143-158
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:143-158
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:143-158
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:143-158
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:160-175
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:160-175
Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:160-175
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:160-175
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-server-ssh-iap
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:160-175
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_77: "Ensure Google compute firewall ingress does not allow on ftp port"
	PASSED for resource: google_compute_firewall.forseti-server-allow-grpc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:177-193
Check: CKV_GCP_75: "Ensure Google compute firewall ingress does not allow unrestricted FTP access"
	PASSED for resource: google_compute_firewall.forseti-server-allow-grpc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:177-193
Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	PASSED for resource: google_compute_firewall.forseti-server-allow-grpc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:177-193
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1
Check: CKV_GCP_88: "Ensure Google compute firewall ingress does not allow unrestricted mysql access"
	PASSED for resource: google_compute_firewall.forseti-server-allow-grpc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:177-193
Check: CKV_GCP_3: "Ensure Google compute firewall ingress does not allow unrestricted rdp access"
	PASSED for resource: google_compute_firewall.forseti-server-allow-grpc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:177-193
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_2
Check: CKV_GCP_30: "Ensure that instances are not configured to use the default service account"
	PASSED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_1
Check: CKV_GCP_31: "Ensure that instances are not configured to use the default service account with full access to all Cloud APIs"
	PASSED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_2
Check: CKV_GCP_36: "Ensure that IP forwarding is not enabled on Instances"
	PASSED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_12
Check: CKV_GCP_34: "Ensure that no instance in the project overrides the project setting for enabling OSLogin(OSLogin needs to be enabled in project metadata for all instances)"
	PASSED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_10
Check: CKV_GCP_35: "Ensure 'Enable connecting to serial ports' is not enabled for VM Instance"
	PASSED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_11
Check: CKV_GCP_39: "Ensure Compute instances are launched with Shielded VM enabled"
	PASSED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_general_y
Check: CKV_GCP_42: "Ensure that Service Account has no Admin privileges"
	PASSED for resource: google_project_iam_member.server_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:62-67
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_4
Check: CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
	PASSED for resource: google_project_iam_member.server_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:62-67
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_10
Check: CKV_GCP_46: "Ensure Default Service account is not used at a project level"
	PASSED for resource: google_project_iam_member.server_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:62-67
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_7
Check: CKV_GCP_41: "Ensure that IAM users are not assigned the Service Account User or Service Account Token Creator roles at project level"
	PASSED for resource: google_project_iam_member.server_roles
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:62-67
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_3
Check: CKV_GCP_45: "Ensure no roles that enable to impersonate and manage all service accounts are used at an organization level"
	PASSED for resource: google_organization_iam_member.org_read
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:69-74
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_6
Check: CKV_GCP_47: "Ensure default service account is not used at an organization level"
	PASSED for resource: google_organization_iam_member.org_read
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:69-74
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_8
Check: CKV_GCP_44: "Ensure no roles that enable to impersonate and manage all service accounts are used at a folder level"
	PASSED for resource: google_folder_iam_member.folder_read
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:76-81
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_5
Check: CKV_GCP_48: "Ensure Default Service account is not used at a folder level"
	PASSED for resource: google_folder_iam_member.folder_read
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:76-81
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_9
Check: CKV_GCP_45: "Ensure no roles that enable to impersonate and manage all service accounts are used at an organization level"
	PASSED for resource: google_organization_iam_member.org_write
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:83-88
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_6
Check: CKV_GCP_47: "Ensure default service account is not used at an organization level"
	PASSED for resource: google_organization_iam_member.org_write
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:83-88
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_8
Check: CKV_GCP_44: "Ensure no roles that enable to impersonate and manage all service accounts are used at a folder level"
	PASSED for resource: google_folder_iam_member.folder_write
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:90-95
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_5
Check: CKV_GCP_48: "Ensure Default Service account is not used at a folder level"
	PASSED for resource: google_folder_iam_member.folder_write
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:90-95
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_9
Check: CKV_GCP_45: "Ensure no roles that enable to impersonate and manage all service accounts are used at an organization level"
	PASSED for resource: google_organization_iam_member.org_cscc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:97-102
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_6
Check: CKV_GCP_47: "Ensure default service account is not used at an organization level"
	PASSED for resource: google_organization_iam_member.org_cscc
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:97-102
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_8
Check: CKV_GCP_45: "Ensure no roles that enable to impersonate and manage all service accounts are used at an organization level"
	PASSED for resource: google_organization_iam_member.cloud_profiler
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:104-109
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_6
Check: CKV_GCP_47: "Ensure default service account is not used at an organization level"
	PASSED for resource: google_organization_iam_member.cloud_profiler
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_iam/main.tf:104-109
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_iam_8
Check: CKV2_GCP_7: "Ensure that a MySQL database instance does not allow anyone to connect with administrative privileges"
	PASSED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103
	Guide: https://docs.bridgecrew.io/docs/ensure-that-a-mysql-database-instance-does-not-allow-anyone-to-connect-with-administrative-privileges
Check: CKV_GCP_32: "Ensure 'Block Project-wide SSH keys' is enabled for VM instances"
	FAILED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_8

		82  | resource "google_compute_instance" "forseti-client" {
		83  |   count                     = var.client_enabled ? 1 : 0
		84  |   name                      = local.client_name
		85  |   zone                      = local.client_zone
		86  |   project                   = var.project_id
		87  |   machine_type              = var.client_type
		88  |   tags                      = var.client_tags
		89  |   allow_stopping_for_update = true
		90  |   metadata                  = var.client_instance_metadata
		91  |   metadata_startup_script   = data.template_file.forseti_client_startup_script[0].rendered
		92  |   dynamic "network_interface" {
		93  |     for_each = local.network_interface
		94  |     content {
		95  |       # Field `address` has been deprecated. Use `network_ip` instead.
		96  |       # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
		97  |       network            = lookup(network_interface.value, "network", null)
		98  |       network_ip         = lookup(network_interface.value, "network_ip", null)
		99  |       subnetwork         = lookup(network_interface.value, "subnetwork", null)
		100 |       subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
		101 | 
		102 |       dynamic "access_config" {
		103 |         for_each = lookup(network_interface.value, "access_config", [])
		104 |         content {
		105 |           nat_ip                 = lookup(access_config.value, "nat_ip", null)
		106 |           network_tier           = lookup(access_config.value, "network_tier", null)
		107 |           public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
		108 |         }
		109 |       }
		110 | 
		111 |       dynamic "alias_ip_range" {
		112 |         for_each = lookup(network_interface.value, "alias_ip_range", [])
		113 |         content {
		114 |           ip_cidr_range         = alias_ip_range.value.ip_cidr_range
		115 |           subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
		116 |         }
		117 |       }
		118 |     }
		119 |   }
		120 | 
		121 |   boot_disk {
		122 |     initialize_params {
		123 |       image = var.client_boot_image
		124 |     }
		125 |   }
		126 | 
		127 |   service_account {
		128 |     email  = var.client_iam_module.forseti-client-service-account
		129 |     scopes = ["cloud-platform"]
		130 |   }
		131 | 
		132 |   dynamic "shielded_instance_config" {
		133 |     for_each = var.client_shielded_instance_config == null ? [] : [var.client_shielded_instance_config]
		134 |     content {
		135 |       enable_secure_boot          = lookup(var.client_shielded_instance_config, "enable_secure_boot", null)
		136 |       enable_vtpm                 = lookup(var.client_shielded_instance_config, "enable_vtpm", null)
		137 |       enable_integrity_monitoring = lookup(var.client_shielded_instance_config, "enable_integrity_monitoring", null)
		138 |     }
		139 |   }
		140 | 
		141 |   depends_on = [
		142 |     null_resource.services-dependency,
		143 |     var.client_config_module,
		144 |   ]
		145 | }

Check: CKV_GCP_38: "Ensure VM disks for critical VMs are encrypted with Customer Supplied Encryption Keys (CSEK)"
	FAILED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/encrypt-boot-disks-for-instances-with-cseks

		82  | resource "google_compute_instance" "forseti-client" {
		83  |   count                     = var.client_enabled ? 1 : 0
		84  |   name                      = local.client_name
		85  |   zone                      = local.client_zone
		86  |   project                   = var.project_id
		87  |   machine_type              = var.client_type
		88  |   tags                      = var.client_tags
		89  |   allow_stopping_for_update = true
		90  |   metadata                  = var.client_instance_metadata
		91  |   metadata_startup_script   = data.template_file.forseti_client_startup_script[0].rendered
		92  |   dynamic "network_interface" {
		93  |     for_each = local.network_interface
		94  |     content {
		95  |       # Field `address` has been deprecated. Use `network_ip` instead.
		96  |       # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
		97  |       network            = lookup(network_interface.value, "network", null)
		98  |       network_ip         = lookup(network_interface.value, "network_ip", null)
		99  |       subnetwork         = lookup(network_interface.value, "subnetwork", null)
		100 |       subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
		101 | 
		102 |       dynamic "access_config" {
		103 |         for_each = lookup(network_interface.value, "access_config", [])
		104 |         content {
		105 |           nat_ip                 = lookup(access_config.value, "nat_ip", null)
		106 |           network_tier           = lookup(access_config.value, "network_tier", null)
		107 |           public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
		108 |         }
		109 |       }
		110 | 
		111 |       dynamic "alias_ip_range" {
		112 |         for_each = lookup(network_interface.value, "alias_ip_range", [])
		113 |         content {
		114 |           ip_cidr_range         = alias_ip_range.value.ip_cidr_range
		115 |           subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
		116 |         }
		117 |       }
		118 |     }
		119 |   }
		120 | 
		121 |   boot_disk {
		122 |     initialize_params {
		123 |       image = var.client_boot_image
		124 |     }
		125 |   }
		126 | 
		127 |   service_account {
		128 |     email  = var.client_iam_module.forseti-client-service-account
		129 |     scopes = ["cloud-platform"]
		130 |   }
		131 | 
		132 |   dynamic "shielded_instance_config" {
		133 |     for_each = var.client_shielded_instance_config == null ? [] : [var.client_shielded_instance_config]
		134 |     content {
		135 |       enable_secure_boot          = lookup(var.client_shielded_instance_config, "enable_secure_boot", null)
		136 |       enable_vtpm                 = lookup(var.client_shielded_instance_config, "enable_vtpm", null)
		137 |       enable_integrity_monitoring = lookup(var.client_shielded_instance_config, "enable_integrity_monitoring", null)
		138 |     }
		139 |   }
		140 | 
		141 |   depends_on = [
		142 |     null_resource.services-dependency,
		143 |     var.client_config_module,
		144 |   ]
		145 | }

Check: CKV_GCP_40: "Ensure that Compute instances do not have public IP addresses"
	FAILED for resource: google_compute_instance.forseti-client
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:82-145
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_public_2

		82  | resource "google_compute_instance" "forseti-client" {
		83  |   count                     = var.client_enabled ? 1 : 0
		84  |   name                      = local.client_name
		85  |   zone                      = local.client_zone
		86  |   project                   = var.project_id
		87  |   machine_type              = var.client_type
		88  |   tags                      = var.client_tags
		89  |   allow_stopping_for_update = true
		90  |   metadata                  = var.client_instance_metadata
		91  |   metadata_startup_script   = data.template_file.forseti_client_startup_script[0].rendered
		92  |   dynamic "network_interface" {
		93  |     for_each = local.network_interface
		94  |     content {
		95  |       # Field `address` has been deprecated. Use `network_ip` instead.
		96  |       # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
		97  |       network            = lookup(network_interface.value, "network", null)
		98  |       network_ip         = lookup(network_interface.value, "network_ip", null)
		99  |       subnetwork         = lookup(network_interface.value, "subnetwork", null)
		100 |       subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
		101 | 
		102 |       dynamic "access_config" {
		103 |         for_each = lookup(network_interface.value, "access_config", [])
		104 |         content {
		105 |           nat_ip                 = lookup(access_config.value, "nat_ip", null)
		106 |           network_tier           = lookup(access_config.value, "network_tier", null)
		107 |           public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
		108 |         }
		109 |       }
		110 | 
		111 |       dynamic "alias_ip_range" {
		112 |         for_each = lookup(network_interface.value, "alias_ip_range", [])
		113 |         content {
		114 |           ip_cidr_range         = alias_ip_range.value.ip_cidr_range
		115 |           subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
		116 |         }
		117 |       }
		118 |     }
		119 |   }
		120 | 
		121 |   boot_disk {
		122 |     initialize_params {
		123 |       image = var.client_boot_image
		124 |     }
		125 |   }
		126 | 
		127 |   service_account {
		128 |     email  = var.client_iam_module.forseti-client-service-account
		129 |     scopes = ["cloud-platform"]
		130 |   }
		131 | 
		132 |   dynamic "shielded_instance_config" {
		133 |     for_each = var.client_shielded_instance_config == null ? [] : [var.client_shielded_instance_config]
		134 |     content {
		135 |       enable_secure_boot          = lookup(var.client_shielded_instance_config, "enable_secure_boot", null)
		136 |       enable_vtpm                 = lookup(var.client_shielded_instance_config, "enable_vtpm", null)
		137 |       enable_integrity_monitoring = lookup(var.client_shielded_instance_config, "enable_integrity_monitoring", null)
		138 |     }
		139 |   }
		140 | 
		141 |   depends_on = [
		142 |     null_resource.services-dependency,
		143 |     var.client_config_module,
		144 |   ]
		145 | }

Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	FAILED for resource: google_compute_firewall.forseti-client-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client/main.tf:174-189
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1

		174 | resource "google_compute_firewall" "forseti-client-ssh-external" {
		175 |   count                   = var.client_enabled && var.manage_firewall_rules && ! var.client_private ? 1 : 0
		176 |   name                    = "forseti-client-ssh-external-${var.suffix}"
		177 |   project                 = local.network_project
		178 |   network                 = var.network
		179 |   target_service_accounts = [var.client_iam_module.forseti-client-service-account]
		180 |   source_ranges           = var.client_ssh_allow_ranges
		181 |   priority                = "100"
		182 | 
		183 |   allow {
		184 |     protocol = "tcp"
		185 |     ports    = ["22"]
		186 |   }
		187 | 
		188 |   depends_on = [null_resource.services-dependency]
		189 | }

Check: CKV_GCP_62: "Bucket should log access"
	FAILED for resource: google_storage_bucket.client_config
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_gcs/main.tf:27-36
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_logging_2

		27 | resource "google_storage_bucket" "client_config" {
		28 |   count              = var.client_enabled ? 1 : 0
		29 |   name               = local.client_bucket_name
		30 |   location           = var.storage_bucket_location
		31 |   project            = var.project_id
		32 |   force_destroy      = true
		33 |   bucket_policy_only = true
		34 | 
		35 |   depends_on = [null_resource.services-dependency]
		36 | }

Check: CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
	FAILED for resource: google_storage_bucket.client_config
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_gcs/main.tf:27-36

		27 | resource "google_storage_bucket" "client_config" {
		28 |   count              = var.client_enabled ? 1 : 0
		29 |   name               = local.client_bucket_name
		30 |   location           = var.storage_bucket_location
		31 |   project            = var.project_id
		32 |   force_destroy      = true
		33 |   bucket_policy_only = true
		34 | 
		35 |   depends_on = [null_resource.services-dependency]
		36 | }

Check: CKV_GCP_29: "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
	FAILED for resource: google_storage_bucket.client_config
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/client_gcs/main.tf:27-36
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_gcs_2

		27 | resource "google_storage_bucket" "client_config" {
		28 |   count              = var.client_enabled ? 1 : 0
		29 |   name               = local.client_bucket_name
		30 |   location           = var.storage_bucket_location
		31 |   project            = var.project_id
		32 |   force_destroy      = true
		33 |   bucket_policy_only = true
		34 | 
		35 |   depends_on = [null_resource.services-dependency]
		36 | }

Check: CKV_GCP_79: "Ensure SQL database is using latest Major version"
	FAILED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103

		64  | resource "google_sql_database_instance" "master" {
		65  |   name             = local.cloudsql_name
		66  |   project          = var.project_id
		67  |   region           = var.cloudsql_region
		68  |   database_version = "MYSQL_5_7"
		69  | 
		70  |   settings {
		71  |     tier              = var.cloudsql_type
		72  |     activation_policy = "ALWAYS"
		73  |     disk_size         = var.cloudsql_disk_size
		74  | 
		75  |     database_flags {
		76  |       name  = "net_write_timeout"
		77  |       value = var.cloudsql_net_write_timeout
		78  |     }
		79  | 
		80  |     backup_configuration {
		81  |       enabled            = true
		82  |       binary_log_enabled = true
		83  |     }
		84  | 
		85  |     ip_configuration {
		86  |       ipv4_enabled    = var.cloudsql_private ? false : true
		87  |       require_ssl     = true
		88  |       private_network = var.cloudsql_private ? data.google_compute_network.cloudsql_private_network.self_link : ""
		89  |     }
		90  | 
		91  |     location_preference {
		92  |       zone = local.cloudsql_zone
		93  |     }
		94  |   }
		95  | 
		96  |   lifecycle {
		97  |     ignore_changes = [
		98  |       settings[0].disk_size,
		99  |     ]
		100 |   }
		101 | 
		102 |   depends_on = [null_resource.services-dependency, google_service_networking_connection.private_vpc_connection]
		103 | }

Check: CKV_GCP_60: "Ensure Cloud SQL database does not have public IP"
	FAILED for resource: google_sql_database_instance.master
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/cloudsql/main.tf:64-103
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_sql_11

		64  | resource "google_sql_database_instance" "master" {
		65  |   name             = local.cloudsql_name
		66  |   project          = var.project_id
		67  |   region           = var.cloudsql_region
		68  |   database_version = "MYSQL_5_7"
		69  | 
		70  |   settings {
		71  |     tier              = var.cloudsql_type
		72  |     activation_policy = "ALWAYS"
		73  |     disk_size         = var.cloudsql_disk_size
		74  | 
		75  |     database_flags {
		76  |       name  = "net_write_timeout"
		77  |       value = var.cloudsql_net_write_timeout
		78  |     }
		79  | 
		80  |     backup_configuration {
		81  |       enabled            = true
		82  |       binary_log_enabled = true
		83  |     }
		84  | 
		85  |     ip_configuration {
		86  |       ipv4_enabled    = var.cloudsql_private ? false : true
		87  |       require_ssl     = true
		88  |       private_network = var.cloudsql_private ? data.google_compute_network.cloudsql_private_network.self_link : ""
		89  |     }
		90  | 
		91  |     location_preference {
		92  |       zone = local.cloudsql_zone
		93  |     }
		94  |   }
		95  | 
		96  |   lifecycle {
		97  |     ignore_changes = [
		98  |       settings[0].disk_size,
		99  |     ]
		100 |   }
		101 | 
		102 |   depends_on = [null_resource.services-dependency, google_service_networking_connection.private_vpc_connection]
		103 | }

Check: CKV_GCP_2: "Ensure Google compute firewall ingress does not allow unrestricted ssh access"
	FAILED for resource: google_compute_firewall.forseti-server-ssh-external
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:143-158
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_1

		143 | resource "google_compute_firewall" "forseti-server-ssh-external" {
		144 |   count                   = var.manage_firewall_rules && ! var.server_private ? 1 : 0
		145 |   name                    = "forseti-server-ssh-external-${local.random_hash}"
		146 |   project                 = local.network_project
		147 |   network                 = var.network
		148 |   target_service_accounts = [var.server_iam_module.forseti-server-service-account]
		149 |   source_ranges           = var.server_ssh_allow_ranges
		150 |   priority                = "100"
		151 | 
		152 |   allow {
		153 |     protocol = "tcp"
		154 |     ports    = ["22"]
		155 |   }
		156 | 
		157 |   depends_on = [null_resource.services-dependency]
		158 | }

Check: CKV_GCP_32: "Ensure 'Block Project-wide SSH keys' is enabled for VM instances"
	FAILED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_networking_8

		225 | resource "google_compute_instance" "forseti-server" {
		226 |   name                      = local.server_name
		227 |   zone                      = local.server_zone
		228 |   project                   = var.project_id
		229 |   machine_type              = var.server_type
		230 |   tags                      = var.server_tags
		231 |   allow_stopping_for_update = true
		232 |   metadata                  = var.server_instance_metadata
		233 |   metadata_startup_script   = data.template_file.forseti_server_startup_script.rendered
		234 | 
		235 |   dynamic "network_interface" {
		236 |     for_each = local.network_interface
		237 |     content {
		238 |       # Field `address` has been deprecated. Use `network_ip` instead.
		239 |       # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
		240 |       network            = lookup(network_interface.value, "network", null)
		241 |       network_ip         = lookup(network_interface.value, "network_ip", null)
		242 |       subnetwork         = lookup(network_interface.value, "subnetwork", null)
		243 |       subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
		244 | 
		245 |       dynamic "access_config" {
		246 |         for_each = lookup(network_interface.value, "access_config", [])
		247 |         content {
		248 |           nat_ip                 = lookup(access_config.value, "nat_ip", null)
		249 |           network_tier           = lookup(access_config.value, "network_tier", null)
		250 |           public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
		251 |         }
		252 |       }
		253 | 
		254 |       dynamic "alias_ip_range" {
		255 |         for_each = lookup(network_interface.value, "alias_ip_range", [])
		256 |         content {
		257 |           ip_cidr_range         = alias_ip_range.value.ip_cidr_range
		258 |           subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
		259 |         }
		260 |       }
		261 |     }
		262 |   }
		263 | 
		264 |   boot_disk {
		265 |     initialize_params {
		266 |       image = var.server_boot_image
		267 |       size  = var.server_boot_disk_size
		268 |       type  = var.server_boot_disk_type
		269 |     }
		270 |   }
		271 | 
		272 |   service_account {
		273 |     email  = var.server_iam_module.forseti-server-service-account
		274 |     scopes = ["cloud-platform"]
		275 |   }
		276 | 
		277 |   dynamic "shielded_instance_config" {
		278 |     for_each = var.server_shielded_instance_config == null ? [] : [var.server_shielded_instance_config]
		279 |     content {
		280 |       enable_secure_boot          = lookup(var.server_shielded_instance_config, "enable_secure_boot", null)
		281 |       enable_vtpm                 = lookup(var.server_shielded_instance_config, "enable_vtpm", null)
		282 |       enable_integrity_monitoring = lookup(var.server_shielded_instance_config, "enable_integrity_monitoring", null)
		283 |     }
		284 |   }
		285 | 
		286 |   depends_on = [
		287 |     var.server_iam_module,
		288 |     var.server_rules_module,
		289 |     null_resource.services-dependency,
		290 |   ]
		291 | }

Check: CKV_GCP_38: "Ensure VM disks for critical VMs are encrypted with Customer Supplied Encryption Keys (CSEK)"
	FAILED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/encrypt-boot-disks-for-instances-with-cseks

		225 | resource "google_compute_instance" "forseti-server" {
		226 |   name                      = local.server_name
		227 |   zone                      = local.server_zone
		228 |   project                   = var.project_id
		229 |   machine_type              = var.server_type
		230 |   tags                      = var.server_tags
		231 |   allow_stopping_for_update = true
		232 |   metadata                  = var.server_instance_metadata
		233 |   metadata_startup_script   = data.template_file.forseti_server_startup_script.rendered
		234 | 
		235 |   dynamic "network_interface" {
		236 |     for_each = local.network_interface
		237 |     content {
		238 |       # Field `address` has been deprecated. Use `network_ip` instead.
		239 |       # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
		240 |       network            = lookup(network_interface.value, "network", null)
		241 |       network_ip         = lookup(network_interface.value, "network_ip", null)
		242 |       subnetwork         = lookup(network_interface.value, "subnetwork", null)
		243 |       subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
		244 | 
		245 |       dynamic "access_config" {
		246 |         for_each = lookup(network_interface.value, "access_config", [])
		247 |         content {
		248 |           nat_ip                 = lookup(access_config.value, "nat_ip", null)
		249 |           network_tier           = lookup(access_config.value, "network_tier", null)
		250 |           public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
		251 |         }
		252 |       }
		253 | 
		254 |       dynamic "alias_ip_range" {
		255 |         for_each = lookup(network_interface.value, "alias_ip_range", [])
		256 |         content {
		257 |           ip_cidr_range         = alias_ip_range.value.ip_cidr_range
		258 |           subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
		259 |         }
		260 |       }
		261 |     }
		262 |   }
		263 | 
		264 |   boot_disk {
		265 |     initialize_params {
		266 |       image = var.server_boot_image
		267 |       size  = var.server_boot_disk_size
		268 |       type  = var.server_boot_disk_type
		269 |     }
		270 |   }
		271 | 
		272 |   service_account {
		273 |     email  = var.server_iam_module.forseti-server-service-account
		274 |     scopes = ["cloud-platform"]
		275 |   }
		276 | 
		277 |   dynamic "shielded_instance_config" {
		278 |     for_each = var.server_shielded_instance_config == null ? [] : [var.server_shielded_instance_config]
		279 |     content {
		280 |       enable_secure_boot          = lookup(var.server_shielded_instance_config, "enable_secure_boot", null)
		281 |       enable_vtpm                 = lookup(var.server_shielded_instance_config, "enable_vtpm", null)
		282 |       enable_integrity_monitoring = lookup(var.server_shielded_instance_config, "enable_integrity_monitoring", null)
		283 |     }
		284 |   }
		285 | 
		286 |   depends_on = [
		287 |     var.server_iam_module,
		288 |     var.server_rules_module,
		289 |     null_resource.services-dependency,
		290 |   ]
		291 | }

Check: CKV_GCP_40: "Ensure that Compute instances do not have public IP addresses"
	FAILED for resource: google_compute_instance.forseti-server
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server/main.tf:225-291
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_public_2

		225 | resource "google_compute_instance" "forseti-server" {
		226 |   name                      = local.server_name
		227 |   zone                      = local.server_zone
		228 |   project                   = var.project_id
		229 |   machine_type              = var.server_type
		230 |   tags                      = var.server_tags
		231 |   allow_stopping_for_update = true
		232 |   metadata                  = var.server_instance_metadata
		233 |   metadata_startup_script   = data.template_file.forseti_server_startup_script.rendered
		234 | 
		235 |   dynamic "network_interface" {
		236 |     for_each = local.network_interface
		237 |     content {
		238 |       # Field `address` has been deprecated. Use `network_ip` instead.
		239 |       # https://github.com/terraform-providers/terraform-provider-google/blob/master/CHANGELOG.md#200-february-12-2019
		240 |       network            = lookup(network_interface.value, "network", null)
		241 |       network_ip         = lookup(network_interface.value, "network_ip", null)
		242 |       subnetwork         = lookup(network_interface.value, "subnetwork", null)
		243 |       subnetwork_project = lookup(network_interface.value, "subnetwork_project", null)
		244 | 
		245 |       dynamic "access_config" {
		246 |         for_each = lookup(network_interface.value, "access_config", [])
		247 |         content {
		248 |           nat_ip                 = lookup(access_config.value, "nat_ip", null)
		249 |           network_tier           = lookup(access_config.value, "network_tier", null)
		250 |           public_ptr_domain_name = lookup(access_config.value, "public_ptr_domain_name", null)
		251 |         }
		252 |       }
		253 | 
		254 |       dynamic "alias_ip_range" {
		255 |         for_each = lookup(network_interface.value, "alias_ip_range", [])
		256 |         content {
		257 |           ip_cidr_range         = alias_ip_range.value.ip_cidr_range
		258 |           subnetwork_range_name = lookup(alias_ip_range.value, "subnetwork_range_name", null)
		259 |         }
		260 |       }
		261 |     }
		262 |   }
		263 | 
		264 |   boot_disk {
		265 |     initialize_params {
		266 |       image = var.server_boot_image
		267 |       size  = var.server_boot_disk_size
		268 |       type  = var.server_boot_disk_type
		269 |     }
		270 |   }
		271 | 
		272 |   service_account {
		273 |     email  = var.server_iam_module.forseti-server-service-account
		274 |     scopes = ["cloud-platform"]
		275 |   }
		276 | 
		277 |   dynamic "shielded_instance_config" {
		278 |     for_each = var.server_shielded_instance_config == null ? [] : [var.server_shielded_instance_config]
		279 |     content {
		280 |       enable_secure_boot          = lookup(var.server_shielded_instance_config, "enable_secure_boot", null)
		281 |       enable_vtpm                 = lookup(var.server_shielded_instance_config, "enable_vtpm", null)
		282 |       enable_integrity_monitoring = lookup(var.server_shielded_instance_config, "enable_integrity_monitoring", null)
		283 |     }
		284 |   }
		285 | 
		286 |   depends_on = [
		287 |     var.server_iam_module,
		288 |     var.server_rules_module,
		289 |     null_resource.services-dependency,
		290 |   ]
		291 | }

Check: CKV_GCP_62: "Bucket should log access"
	FAILED for resource: google_storage_bucket.server_config
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_gcs/main.tf:30-38
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_logging_2

		30 | resource "google_storage_bucket" "server_config" {
		31 |   name               = local.server_bucket_name
		32 |   location           = var.storage_bucket_location
		33 |   project            = var.project_id
		34 |   force_destroy      = true
		35 |   bucket_policy_only = true
		36 | 
		37 |   depends_on = [null_resource.services-dependency]
		38 | }

Check: CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
	FAILED for resource: google_storage_bucket.server_config
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_gcs/main.tf:30-38

		30 | resource "google_storage_bucket" "server_config" {
		31 |   name               = local.server_bucket_name
		32 |   location           = var.storage_bucket_location
		33 |   project            = var.project_id
		34 |   force_destroy      = true
		35 |   bucket_policy_only = true
		36 | 
		37 |   depends_on = [null_resource.services-dependency]
		38 | }

Check: CKV_GCP_29: "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
	FAILED for resource: google_storage_bucket.server_config
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_gcs/main.tf:30-38
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_gcs_2

		30 | resource "google_storage_bucket" "server_config" {
		31 |   name               = local.server_bucket_name
		32 |   location           = var.storage_bucket_location
		33 |   project            = var.project_id
		34 |   force_destroy      = true
		35 |   bucket_policy_only = true
		36 | 
		37 |   depends_on = [null_resource.services-dependency]
		38 | }

Check: CKV_GCP_62: "Bucket should log access"
	FAILED for resource: google_storage_bucket.cai_export
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_gcs/main.tf:40-59
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_logging_2

		40 | resource "google_storage_bucket" "cai_export" {
		41 |   count              = var.enable_cai_bucket ? 1 : 0
		42 |   name               = local.storage_cai_bucket_name
		43 |   location           = var.bucket_cai_location
		44 |   project            = var.project_id
		45 |   force_destroy      = true
		46 |   bucket_policy_only = true
		47 | 
		48 |   lifecycle_rule {
		49 |     action {
		50 |       type = "Delete"
		51 |     }
		52 | 
		53 |     condition {
		54 |       age = var.bucket_cai_lifecycle_age
		55 |     }
		56 |   }
		57 | 
		58 |   depends_on = [null_resource.services-dependency]
		59 | }

Check: CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
	FAILED for resource: google_storage_bucket.cai_export
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_gcs/main.tf:40-59

		40 | resource "google_storage_bucket" "cai_export" {
		41 |   count              = var.enable_cai_bucket ? 1 : 0
		42 |   name               = local.storage_cai_bucket_name
		43 |   location           = var.bucket_cai_location
		44 |   project            = var.project_id
		45 |   force_destroy      = true
		46 |   bucket_policy_only = true
		47 | 
		48 |   lifecycle_rule {
		49 |     action {
		50 |       type = "Delete"
		51 |     }
		52 | 
		53 |     condition {
		54 |       age = var.bucket_cai_lifecycle_age
		55 |     }
		56 |   }
		57 | 
		58 |   depends_on = [null_resource.services-dependency]
		59 | }

Check: CKV_GCP_29: "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
	FAILED for resource: google_storage_bucket.cai_export
	File: /.external_modules/github.com/terraform-google-modules/terraform-google-forseti/v5.2.2/modules/server_gcs/main.tf:40-59
	Guide: https://docs.bridgecrew.io/docs/bc_gcp_gcs_2

		40 | resource "google_storage_bucket" "cai_export" {
		41 |   count              = var.enable_cai_bucket ? 1 : 0
		42 |   name               = local.storage_cai_bucket_name
		43 |   location           = var.bucket_cai_location
		44 |   project            = var.project_id
		45 |   force_destroy      = true
		46 |   bucket_policy_only = true
		47 | 
		48 |   lifecycle_rule {
		49 |     action {
		50 |       type = "Delete"
		51 |     }
		52 | 
		53 |     condition {
		54 |       age = var.bucket_cai_lifecycle_age
		55 |     }
		56 |   }
		57 | 
		58 |   depends_on = [null_resource.services-dependency]
		59 | }
```
