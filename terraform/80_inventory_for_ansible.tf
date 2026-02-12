# 80_inventory_for_ansible.tf

# Хост для Ansible
resource "local_file" "inventory" {
  content = <<-INI
  [bastion]
  ${yandex_compute_instance.bastion.name} ansible_host=${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}

  [nginx]
  ${yandex_compute_instance.web_a_nginx.name} ansible_host=${yandex_compute_instance.web_a_nginx.network_interface[0].ip_address}
  ${yandex_compute_instance.web_b_nginx.name} ansible_host=${yandex_compute_instance.web_b_nginx.network_interface[0].ip_address}
  
  [zabbix]
  ${yandex_compute_instance.web_zabbix.name} ansible_host=${yandex_compute_instance.web_zabbix.network_interface[0].ip_address}

  [elasticsearch]
  ${yandex_compute_instance.web_elasticsearch.name} ansible_host=${yandex_compute_instance.web_elasticsearch.network_interface[0].ip_address}

  [kibana]
  ${yandex_compute_instance.web_kibana.name} ansible_host=${yandex_compute_instance.web_kibana.network_interface[0].ip_address}

  [all:vars]
  ansible_user=localadmin
  ansible_python_interpreter=/usr/bin/python3

  [nginx:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'

  [zabbix:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'

  [elasticsearch:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'

  [kibana:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -p 22 -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'
  INI

  # Пример подключения по SSH
  # Пример к bastion: ssh -l localadmin ${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}
  # Пример к kibana: ssh -J localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address} localadmin@${yandex_compute_instance.web_kibana.network_interface[0].ip_address}

  filename = "../ansible/inventory.ini"
}
