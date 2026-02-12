# 07_load_balancer.tf

# Создание Application Load Balancer  
resource "yandex_alb_load_balancer" "web_alb" {
  name       = "web-alb-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  # Политика размещения ALB по зонам
  allocation_policy {
    # Зона размещения a
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public_a.id
    }

    # Зона размещения b
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.public_b.id
    }
  }

  listener {
    name = "http-listener"

    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }

    # HTTP конфигурация обработчика
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }

  # Привязка ALB к группе безопасности
  security_group_ids = [yandex_vpc_security_group.alb_sg.id]
}
