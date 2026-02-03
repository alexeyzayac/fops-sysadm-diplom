resource "yandex_alb_http_router" "web_http_router" {
  name = "web-http-router-${var.flow}"
}

resource "yandex_alb_virtual_host" "web_virtual_host" {
  name           = "web-virtual-host-${var.flow}"
  http_router_id = yandex_alb_http_router.web_http_router.id

  route {
    name = "root-route"

    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }

      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend_group.id
        timeout          = "30s"
      }
    }
  }

  authority = ["*"]
}
