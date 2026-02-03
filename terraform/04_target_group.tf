resource "yandex_alb_target_group" "web_target_group" {
  name = "web-target-group-${var.flow}"

  target {
    subnet_id = yandex_vpc_subnet.develop_a.id
    ip_address = yandex_compute_instance.web_a.network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.develop_b.id
    ip_address = yandex_compute_instance.web_b.network_interface[0].ip_address
  }
}
