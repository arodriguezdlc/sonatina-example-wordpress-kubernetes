variable "user_component" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_password" {
  type = string
}

variable "image" {
  type = string
}

variable "replicas" {
  type = number
}

variable "cpu_request" {
  type = string
}

variable "cpu_limit" {
  type = string
}

variable "ram_request" {
  type = string
}

variable "ram_limit" {
  type = string
}