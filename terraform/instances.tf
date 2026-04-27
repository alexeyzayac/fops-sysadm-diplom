data "yandex_compute_image" "ubuntu" {
  family = local.default_vm.image_family
}

resource "yandex_compute_instance" "this" {
  for_each = local.servers

  name        = each.key
  hostname    = each.value.hostname
  platform_id = local.default_vm.platform_id
  zone        = each.value.zone

  resources {
    cores         = each.value.cores
    memory        = each.value.memory
    core_fraction = local.default_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type     = "network-hdd"
      size     = each.value.disk
    }
  }

  metadata = {
    user-data = templatefile(
      lookup(each.value, "cloud_init_file", local.default_vm.cloud_init_file),
      { public_key = tls_private_key.ssh.public_key_openssh }
    )
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = local.default_vm.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.this[each.value.subnet].id
    nat       = each.value.nat
    security_group_ids = [
      for sg_name in each.value.security_groups : local.sg_map[sg_name]
    ]
  }
}