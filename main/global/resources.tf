terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.4"
    }
  }
}

provider "kubernetes" {}

variable "root_password" {
  type = string
}

variable "mysql_image" {
  type = string
}

variable "database_cpu_limit" {
  type = string
}

variable "database_cpu_request" {
  type = string
}

variable "database_ram_limit" {
  type = string
}

variable "database_ram_request" {
  type = string
}

variable "database_storage" {
  type = string
}

module "database" {
  source = "../../modules/database-server"

  root_password = var.root_password
  mysql_image   = var.mysql_image

  cpu_request = var.database_cpu_request
  cpu_limit   = var.database_cpu_limit
  ram_request = var.database_ram_request
  ram_limit   = var.database_ram_limit
  storage     = var.database_storage
}
