# 08_compute_image.tf

# Получение данных об образе ОС Ubuntu 24.04 LTS
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}
