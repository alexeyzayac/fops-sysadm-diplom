# 12_kibana.tf

# ВМ в зоне d (kibana-server)
resource "yandex_compute_instance" "web_kibana" {
  name        = "kibana-server"
  hostname    = "kibana-server"
  platform_id = "standard-v3"
  zone        = "ru-central1-d"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 20
    }
  }

  metadata = {
    user-data          = file("../cloud-init/cloud-init-kibana.yml")
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public_d.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.kibana_sg.id]
  }
}
