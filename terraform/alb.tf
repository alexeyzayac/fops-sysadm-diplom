resource "yandex_alb_target_group" "web_target_group" {
  name = "web-target-group-${var.project}"

  target {
    subnet_id  = yandex_vpc_subnet.this["subnet_a"].id
    ip_address = yandex_compute_instance.this["nginx-1"].network_interface[0].ip_address
  }

  target {
    subnet_id  = yandex_vpc_subnet.this["subnet_b"].id
    ip_address = yandex_compute_instance.this["nginx-2"].network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "web_backend_group" {
  name = "web-backend-group-${var.project}"

  http_backend {
    name             = "web-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_target_group.id]

    healthcheck {
      timeout             = "1s"
      interval            = "2s"
      healthy_threshold   = 2
      unhealthy_threshold = 3

      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "web_router" {
  name = "web-router-${var.project}"
}

resource "yandex_alb_virtual_host" "web_virtual_host" {
  name           = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web_router.id

  route {
    name = "root-route"

    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend_group.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web_alb" {
  name       = "web-alb-${var.project}"
  network_id = yandex_vpc_network.develop.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.this["subnet_a"].id
    }

    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.this["subnet_b"].id
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

    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }

  security_group_ids = [yandex_vpc_security_group.alb_sg.id]
}