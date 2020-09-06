variable "httpd_version" {
  type = string
}

variable "name" {
  type = string
}

variable "port" {
  type = number
}

variable "sentence" {
  type = string
}

module "docker-httpd" {
  source = "../../modules/docker-httpd"

  name  = var.name
  httpd_version = var.httpd_version
  port = var.port
  sentence = var.sentence
}
