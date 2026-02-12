# 06_http_router.tf

# Обьявление HTTP Router
resource "yandex_alb_http_router" "web_router" {
  name = "web-router-${var.flow}"
}

# Virtual Host + Route
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
