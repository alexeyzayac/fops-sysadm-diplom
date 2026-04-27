output "nginx_1_ip" {
  description = "Private IP of nginx-1"
  value       = yandex_compute_instance.this["nginx-1"].network_interface[0].ip_address
}

output "nginx_2_ip" {
  description = "Private IP of nginx-2"
  value       = yandex_compute_instance.this["nginx-2"].network_interface[0].ip_address
}

output "zabbix_public_ip" {
  description = "Public IP of Zabbix server"
  value       = yandex_compute_instance.this["zabbix"].network_interface[0].nat_ip_address
}

output "elasticsearch_ip" {
  description = "Private IP of Elasticsearch"
  value       = yandex_compute_instance.this["elasticsearch"].network_interface[0].ip_address
}

output "kibana_public_ip" {
  description = "Public IP of Kibana"
  value       = yandex_compute_instance.this["kibana"].network_interface[0].nat_ip_address
}

output "alb_public_ip" {
  description = "Public IP of ALB"
  value       = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}

output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = yandex_compute_instance.this["bastion"].network_interface[0].nat_ip_address
}