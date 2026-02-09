### Inventory для Ansible
resource "local_file" "inventory" {
  content = <<-XYZ
  [webservers]
  ${yandex_compute_instance.web_a_nginx.name} ansible_host=${yandex_compute_instance.web_a_nginx.network_interface[0].nat_ip_address}
  ${yandex_compute_instance.web_b_nginx.name} ansible_host=${yandex_compute_instance.web_b_nginx.network_interface[0].nat_ip_address}
  
  [zabbix]
  ${yandex_compute_instance.web_zabbix.name} ansible_host=${yandex_compute_instance.web_zabbix.network_interface[0].nat_ip_address}

  [elasticsearch]
  ${yandex_compute_instance.web_elasticsearch.name} ansible_host=${yandex_compute_instance.web_elasticsearch.network_interface[0].nat_ip_address}

  [all:vars]
    ansible_user=localadmin
    ansible_ssh_private_key_file=~/.ssh/yandex.cloud/cloud-alexeyzayac
    ansible_python_interpreter=/usr/bin/python3


  XYZ

  filename = "../ansible/.hosts.ini"
}
