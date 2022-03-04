
# Get the project and organization details
data "google_organization" "default" {
  organization = "organizations/${var.organization_id}"
}

resource "google_project_service" "required_apis" {
  for_each = toset(["cloudresourcemanager.googleapis.com", "serviceusage.googleapis.com", "compute.googleapis.com"])
  service  = each.key
}

resource "google_service_account" "sa" {
  account_id = "cloud-foundation-forseti"
}

//noinspection MissingModule
module "forseti" {
  source = "terraform-google-modules/forseti/google"

  domain     = data.google_organization.default.domain
  project_id = var.project_id
  org_id     = var.organization_id

  config_validator_enabled = var.config_validator_enabled
  gsuite_admin_email       = var.gsuite_admin_email
  forseti_version          = var.forseti_version
}
