# Блок настроек Terraform
terraform {
  # Определение необходимых провайдеров
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.132.0"
    }
  }

  # Минимальная версия Terraform
  required_version = "~> 1.6.0"
}

# Настройка провайдера Yandex Cloud
provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  service_account_key_file = file("~/.yandex/authorized_key.json")
} 