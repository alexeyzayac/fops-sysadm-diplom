output "nginx_vm_a_public_ip" {
  value = yandex_compute_instance.web_a_nginx.network_interface[0].nat_ip_address
}

output "nginx_vm_b_public_ip" {
  value = yandex_compute_instance.web_b_nginx.network_interface[0].nat_ip_address
}

output "alb_public_ip" {
  value = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}
