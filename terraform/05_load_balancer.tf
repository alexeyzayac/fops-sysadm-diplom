# Создание сетевого балансировщика нагрузки
resource "yandex_lb_network_load_balancer" "web_balancer" {
  name = "web-balancer-${var.flow}"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_target_group.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}