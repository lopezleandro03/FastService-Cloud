variable "webapp_name" {
  description = "Name of app service"
  type        = string
  default     = "fastserviceweb"
}

variable "resource_group" {
  description = "Resource group"
  type = object({
    location = string
    name     = string
  })
}