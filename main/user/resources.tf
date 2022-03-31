terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "1.13.4"
    }
  }
}

provider "kubernetes" {}

variable "user_component" {
  type = string
}

variable "database_password" {
  type = string
}

variable "wordpress_image" {
  type = string
}

variable "mysql_image" {
  type = string
}

variable "wordpress_replicas" {
  type = number
}

variable "wordpress_cpu_limit" {
  type = string
}

variable "wordpress_cpu_request" {
  type = string
}

variable "wordpress_ram_limit" {
  type = string
}

variable "wordpress_ram_request" {
  type = string
}
 
module "wordpress" {
  source = "../../../modules/wordpress"

  depends_on = [ module.database_user ]

  user_component = var.user_component
  
  database_user     = var.user_component
  database_password = var.database_password

  image = var.wordpress_image

  replicas    = var.wordpress_replicas
  cpu_request = var.wordpress_cpu_request
  cpu_limit   = var.wordpress_cpu_limit
  ram_request = var.wordpress_ram_request
  ram_limit   = var.wordpress_ram_limit
}

module "database_user" {
  source = "../../../modules/database-user"

  user = var.user_component
  password = var.database_password

  mysql_image = var.mysql_image
}