# Создание динамической таргет-группы для балансировки нагрузки
resource "yandex_lb_target_group" "web_target_group" {
  name      = "web-target-group-${var.flow}"
  region_id = "ru-central1"

  # Динамическое добавление целей из списка ВМ
  dynamic "target" {
    for_each = [
      {
        vm       = yandex_compute_instance.web_a
        subnet   = yandex_vpc_subnet.develop_a
      },
      {
        vm     = yandex_compute_instance.web_b
        subnet = yandex_vpc_subnet.develop_b
      }
    ]
    
    content {
      subnet_id = target.value.subnet.id
      address   = target.value.vm.network_interface[0].ip_address
    }
  }
}
