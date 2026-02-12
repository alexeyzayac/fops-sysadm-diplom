# 04_target_group.tf

resource "yandex_alb_target_group" "web_target_group" {
  name = "web-target-group-${var.flow}"

  target {
    subnet_id  = yandex_vpc_subnet.subnet_a.id
    ip_address = yandex_compute_instance.web_a_nginx.network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.subnet_b.id
    ip_address = yandex_compute_instance.web_b_nginx.network_interface[0].ip_address
  }
}