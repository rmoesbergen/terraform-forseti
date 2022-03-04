
locals {
  default_org_roles  = ["roles/resourcemanager.organizationAdmin", "roles/iam.securityReviewer"]
  enforcer_org_roles = ["roles/logging.configWriter", "roles/iam.organizationRoleAdmin"]

  default_project_roles = [
    "roles/compute.instanceAdmin",
    "roles/compute.networkViewer",
    "roles/compute.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/iam.serviceAccountUser",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
  enforcer_project_roles = ["roles/pubsub.admin"]
  vpc_host_project_roles = ["roles/compute.securityAdmin", "roles/compute.networkAdmin"]

  org_roles     = var.enable_policy_enforcer ? concat(local.enforcer_org_roles, local.default_org_roles) : local.default_org_roles
  project_roles = var.enable_policy_enforcer ? concat(local.enforcer_project_roles, local.default_project_roles) : local.default_project_roles
}


resource "google_organization_iam_member" "forseti_org_iam" {
  for_each = toset(local.org_roles)
  member   = "serviceAccount:${google_service_account.sa.email}"
  org_id   = var.organization_id
  role     = each.key
}

resource "google_project_iam_member" "forseti_project_iam" {
  for_each = toset(local.project_roles)
  member   = "serviceAccount:${google_service_account.sa.email}"
  project  = var.project_id
  role     = each.key
}

resource "google_project_iam_member" "forseti_shared_vpc_project_iam" {
  for_each = toset(var.vpc_host_project_id == "" ? [] : local.vpc_host_project_roles)
  member   = "serviceAccount:${google_service_account.sa.email}"
  project  = var.vpc_host_project_id
  role     = each.key
}
