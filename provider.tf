terraform {
  required_providers {
    google = {}
  }
  required_version = "~> 1.1.0"
}

## To use a service account credentials file, uncomment the following:
#provider "google" {
#  credentials = file("credentials.json")
#}
