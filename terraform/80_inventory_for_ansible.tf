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

[internal:children]
nginx
zabbix
elasticsearch
kibana

[all:vars]
ansible_user=localadmin
ansible_ssh_private_key_file=../ssh/cloud-${var.flow}
ansible_python_interpreter=/usr/bin/python3

[internal:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -i ../ssh/cloud-${var.flow} -p 22 -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'

# Примеры подключения по SSH
# К bastion: ssh -l localadmin ${yandex_compute_instance.bastion.network_interface[0].nat_ip_address} -i ../ssh/cloud-${var.flow}
# К kibana: ssh -i ../ssh/cloud-${var.flow} -o ProxyCommand="ssh -i ../ssh/cloud-${var.flow} -W %h:%p -q localadmin@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}" localadmin@${yandex_compute_instance.web_kibana.network_interface[0].ip_address}
INI

  filename = "../ansible/inventory.ini"
}