resource "yandex_compute_snapshot_schedule" "daily_weekly" {
  name = "daily-weekly-${var.project}"

  schedule_policy {
    expression = "0 2 * * *"
  }

  retention_period = "168h"

  snapshot_spec {
    description = "Daily snapshot, retained for 1 week"
    labels = {
      environment = var.project
    }
  }

  disk_ids = [for _, instance in yandex_compute_instance.this : instance.boot_disk[0].disk_id]
}