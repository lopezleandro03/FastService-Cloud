variable "server_name" {
  description = "Name of sql server"
  type        = string
  default     = "fastservicebackups"
}

variable "backup_storage_name" {
  description = "Name of storage account used for backups"
  type        = string
  default     = "fastservicebackups"
}

variable "ssadminpassword" {
  description = "sql server admin password"
  type        = string
}

variable "resource_group" {
  description = "Resource group"
  type = object({
    location = string
    name     = string
  })
}