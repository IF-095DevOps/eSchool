# Specify the provider (GCP)
provider "google" {
  credentials = "${file("gcp.json")}"
  project = "${var.project_name}"
  region = "${var.region}"
  }
