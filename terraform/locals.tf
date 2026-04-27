locals {
  default_vm = {
    platform_id   = "standard-v3"
    core_fraction = 20
    preemptible   = true
    image_family  = "ubuntu-2404-lts"
    ssh_user      = "localadmin"
    cloud_init_file = "cloud-init/cloud-init.tpl"
  }

  servers = {
    "bastion" = {
      hostname        = "bastion-server"
      zone            = "ru-central1-d"
      subnet          = "subnet_d"
      cores           = 2
      memory          = 1
      disk            = 10
      nat             = true
      security_groups = ["bastion_sg"]
    }
    "nginx-1" = {
      hostname        = "nginx-1-server"
      zone            = "ru-central1-a"
      subnet          = "subnet_a"
      cores           = 2
      memory          = 2
      disk            = 10
      nat             = false
      security_groups = ["web_sg"]
      cloud_init_file = "cloud-init/cloud-init-nginx.tpl"   
    },
    "nginx-2" = {
      hostname        = "nginx-2-server"
      zone            = "ru-central1-b"
      subnet          = "subnet_b"
      cores           = 2
      memory          = 2
      disk            = 10
      nat             = false
      security_groups = ["web_sg"]
      cloud_init_file = "cloud-init/cloud-init-nginx.tpl"   
    },
    "zabbix" = {
      hostname        = "zabbix-server"
      zone            = "ru-central1-d"
      subnet          = "subnet_d"
      cores           = 2
      memory          = 2
      disk            = 10
      nat             = true
      security_groups = ["zabbix_sg"]
    },
    "elasticsearch" = {
      hostname        = "elasticsearch-server"
      zone            = "ru-central1-d"
      subnet          = "subnet_d"
      cores           = 2
      memory          = 2
      disk            = 20
      nat             = false
      security_groups = ["elasticsearch_sg"]
    },
    "kibana" = {
      hostname        = "kibana-server"
      zone            = "ru-central1-d"
      subnet          = "subnet_d"
      cores           = 2
      memory          = 2
      disk            = 20
      nat             = true
      security_groups = ["kibana_sg"]
    },
  }

  sg_map = {
    web_sg           = yandex_vpc_security_group.web_sg.id
    zabbix_sg        = yandex_vpc_security_group.zabbix_sg.id
    elasticsearch_sg = yandex_vpc_security_group.elasticsearch_sg.id
    kibana_sg        = yandex_vpc_security_group.kibana_sg.id
    bastion_sg       = yandex_vpc_security_group.bastion_sg.id
    alb_sg           = yandex_vpc_security_group.alb_sg.id
  }
} 