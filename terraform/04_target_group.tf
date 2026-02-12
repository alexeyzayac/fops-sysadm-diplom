# 04_target_group.tf

# Группа бэкендов
resource "yandex_alb_target_group" "web_target_group" {
  name = "web-target-group-${var.flow}"

  # Первый бэкенд-сервер (nginx в зоне a)
  target {
    subnet_id  = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web_a_nginx.network_interface[0].ip_address
  }

  # Второй бэкенд-сервер (nginx в зоне b)
  target {
    subnet_id  = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web_b_nginx.network_interface[0].ip_address
  }
}
