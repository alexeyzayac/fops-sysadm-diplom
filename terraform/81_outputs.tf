output "_01_nginx-1-server" {
  value = yandex_compute_instance.web_a_nginx.network_interface[0].nat_ip_address
}

output "_02_nginx-2-server" {
  value = yandex_compute_instance.web_b_nginx.network_interface[0].nat_ip_address
}

output "_03_zabbix-server" {
  value = yandex_compute_instance.web_zabbix.network_interface[0].nat_ip_address
}

output "_04_elasticsearch-server" {
  value = yandex_compute_instance.web_elasticsearch.network_interface[0].nat_ip_address
}

output "_05_kibana-server" {
  value = yandex_compute_instance.web_kibana.network_interface[0].nat_ip_address
}

output "_00_web-alb-server" {
  value = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
