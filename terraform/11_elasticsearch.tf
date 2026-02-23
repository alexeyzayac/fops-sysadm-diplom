# 11_elasticsearch.tf

resource "yandex_compute_instance" "web_elasticsearch" {
  name        = "elasticsearch-server"
  hostname    = "elasticsearch-server"
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
    user-data = templatefile("../cloud-init/cloud-init-elasticsearch.tpl", {
      public_key = tls_private_key.ssh.public_key_openssh
    })
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet_d.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id]
  }
}