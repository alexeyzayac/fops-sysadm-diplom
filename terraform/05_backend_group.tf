resource "yandex_alb_backend_group" "web_backend_group" {
  name = "web-backend-group-${var.flow}"

  session_affinity {
    connection {
      source_ip = true
    }
  }

  stream_backend {
    name                   = "web-backend"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_alb_target_group.web_target_group.id]
    load_balancing_config {
      panic_threshold      = 90
    }
    enable_proxy_protocol  = true
    
    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      
      http_healthcheck {
        path              = "/"
      }
    }
  }
}
