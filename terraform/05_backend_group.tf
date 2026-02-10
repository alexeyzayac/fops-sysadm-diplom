resource "yandex_alb_backend_group" "web_backend_group" {
  name = "web-backend-group-${var.flow}"

  http_backend {
    name             = "web-backend"
    port             = 80
    target_group_ids = [yandex_alb_target_group.web_target_group.id]

    healthcheck {
      timeout  = "1s"
      interval = "2s"
      healthy_threshold = 2
      unhealthy_threshold = 3

      http_healthcheck {
        path = "/"
      }
    }
  }
}
