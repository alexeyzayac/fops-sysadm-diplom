# 79_snapshot_schedule.tf

# Расписание ежедневных снапшотов для всех дисков ВМ
resource "yandex_compute_snapshot_schedule" "daily_weekly" {
  name = "daily-weekly-${var.flow}"

  # Ежедневно в 2:00 по московскому времени (UTC+3)
  schedule_policy {
    expression = "0 2 * * *"
  }

  retention_period = "168h" # 7 дней

  # Ежедневный снимок, сохраняемый в течение 1 недели
  snapshot_spec {
    description = "Daily snapshot, retained for 1 week"
    labels = {
      environment = var.flow
    }
  }

  # Список дисков ВМ
  disk_ids = [
    yandex_compute_instance.web_a_nginx.boot_disk[0].disk_id,
    yandex_compute_instance.web_b_nginx.boot_disk[0].disk_id,
    yandex_compute_instance.web_zabbix.boot_disk[0].disk_id,
    yandex_compute_instance.web_elasticsearch.boot_disk[0].disk_id,
    yandex_compute_instance.web_kibana.boot_disk[0].disk_id,
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
  ]
}