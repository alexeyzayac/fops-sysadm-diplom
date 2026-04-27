### variables.tf

### Переменные проекта
variable "project" {
  description = "Уникальный идентификатор проекта/потока"
  type        = string
  default     = "zayac-02-2026"
}

variable "cloud_id" {
  type      = string
  sensitive = true
  default = "b1guknff8nknnqp3g18s"
}

variable "folder_id" {
  type      = string
  sensitive = true
  default = "b1gb00710li9ve0ujpkm"
}

###

variable "network_name" {
  description = "Base name for the VPC network"
  type        = string
  default     = "develop"
}

variable "create_nat_gateway" {
  description = "Whether to create a shared NAT gateway and a default route to it"
  type        = bool
  default     = true
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    zone    = string
    cidr    = string
  }))
  default = {
    subnet_a = { zone = "ru-central1-a", cidr = "10.10.1.0/24" }
    subnet_b = { zone = "ru-central1-b", cidr = "10.10.2.0/24" }
    subnet_d = { zone = "ru-central1-d", cidr = "10.10.3.0/24" }
  }
}