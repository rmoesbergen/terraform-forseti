
variable "organization_id" {
  description = "The ID of the organization where Forseti will be installed"
  type        = string
}
variable "project_id" {
  description = "The ID of the project where Forseti will be installed"
  type        = string
}

variable "gsuite_admin_email" {
  description = "Google Workspace superadmin e-mail address"
}
variable "forseti_version" {
  description = "The version of Forseti to install"
  default     = "v2.25.2"
}
variable "config_validator_enabled" {
  description = "Enable Config Validator Forseti component"
  type        = bool
  default     = true
}
variable "enable_policy_enforcer" {
  description = "Enable policy enforcer component"
  type        = bool
  default     = true
}
variable "vpc_host_project_id" {
  description = "Project ID of the VPC host project. Leave empty if not using a shared VPC"
  default     = ""
}
