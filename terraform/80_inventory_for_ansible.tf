# 80_inventory_for_ansible.tf

# Хост для Ansible
resource "local_file" "inventory" {
  content = <<-INI
  [nginx]
  ${yandex_compute_instance.web_a_nginx.name} ansible_host=${yandex_compute_instance.web_a_nginx.network_interface[0].ip_address}
  ${yandex_compute_instance.web_b_nginx.name} ansible_host=${yandex_compute_instance.web_b_nginx.network_interface[0].ip_address}
  
  [zabbix]
  ${yandex_compute_instance.web_zabbix.name} ansible_host=${yandex_compute_instance.web_zabbix.network_interface[0].nat_ip_address}

  [elasticsearch]
  ${yandex_compute_instance.web_elasticsearch.name} ansible_host=${yandex_compute_instance.web_elasticsearch.network_interface[0].ip_address}

  [kibana]
  ${yandex_compute_instance.web_kibana.name} ansible_host=${yandex_compute_instance.web_kibana.network_interface[0].nat_ip_address}

  [bastion]
  ${yandex_compute_instance.bastion.name} ansible_host=${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}

  [all:vars]
  ansible_user=localadmin
  ansible_ssh_private_key_file=~/.ssh/yandex.cloud/cloud-alexeyzayac
  ansible_python_interpreter=/usr/bin/python3

  [nginx:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/yandex.cloud/cloud-alexeyzayac -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'

  [elasticsearch:vars]
  ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/yandex.cloud/cloud-alexeyzayac -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'
  INI

  filename = "../ansible/inventory.ini"
}
