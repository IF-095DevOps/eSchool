variable "region" {
  description = "The zone that the machine should be created in"
  default = "us-central1"
}

variable "zone" {
  description = "The zone that the machine should be created in"
  default     = "us-central1-c"
}

variable "project_name" {
  description = "The ID of the project"
  default     = "mydevops-234619"
}

variable "name" {
  description = "Name prefix for the nodes"
  default     = "ci-sonarqube"
}

variable "machine_type" {
  default     = "n1-standard-1"
}

variable "image_family" {
  default = "centos-7"
}

variable "image_project" {
  default = "centos-cloud"
}