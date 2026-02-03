# Получение данных об образе ОС Ubuntu 24.04 LTS
data "yandex_compute_image" "ubuntu_2404_lts" {
  family = "ubuntu-2404-lts"
}

# ВМ в зоне A
resource "yandex_compute_instance" "web_a" {
  name        = "computer-vm-1"
  hostname    = "computer-vm-1"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("../cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { 
    preemptible = true 
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_a.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.LAN.id,
      yandex_vpc_security_group.web_sg.id
    ]
  }
}

# ВМ в зоне B
resource "yandex_compute_instance" "web_b" {
  name        = "computer-vm-2"
  hostname    = "computer-vm-2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_2404_lts.image_id
      type     = "network-hdd"
      size     = 10
    }
  }

  metadata = {
    user-data          = file("../cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { 
    preemptible = true 
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.LAN.id,
      yandex_vpc_security_group.web_sg.id
    ]
  }
}

# Inventory для Ansible
resource "local_file" "inventory" {
  content = <<-XYZ
  [webservers]
  ${yandex_compute_instance.web_a.name} ansible_host=${yandex_compute_instance.web_a.network_interface[0].nat_ip_address}
  ${yandex_compute_instance.web_b.name} ansible_host=${yandex_compute_instance.web_b.network_interface[0].nat_ip_address}

  [webservers:vars]
    ansible_user=localadmin
    ansible_ssh_private_key_file=~/.ssh/yandex.cloud/cloud-alexeyzayac
    ansible_python_interpreter=/usr/bin/python3
  XYZ

  filename = "../.hosts.ini"
}