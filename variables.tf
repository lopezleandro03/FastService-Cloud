variable "ssadminpassword" {
  type      = string
  sensitive = true
}

variable "tenant_id" {
  type      = string
  sensitive = true
}

variable "client_id" {
  type      = string
  sensitive = true
}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "resource_group" {
  type = string
}

variable "webapp_name" {
  type = string
}

variable "server_name" {
  type = string
}

variable "location" {
  type = string
}