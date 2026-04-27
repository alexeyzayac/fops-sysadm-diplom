resource "local_file" "inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    bastion_ip       = yandex_compute_instance.this["bastion"].network_interface[0].nat_ip_address
    nginx1_ip        = yandex_compute_instance.this["nginx-1"].network_interface[0].ip_address
    nginx2_ip        = yandex_compute_instance.this["nginx-2"].network_interface[0].ip_address
    zabbix_ip        = yandex_compute_instance.this["zabbix"].network_interface[0].ip_address
    elasticsearch_ip = yandex_compute_instance.this["elasticsearch"].network_interface[0].ip_address
    kibana_ip        = yandex_compute_instance.this["kibana"].network_interface[0].ip_address
    ssh_key_path     = "../ssh/cloud-${var.project}"
    ssh_user         = local.default_vm.ssh_user
  })
  filename = "../ansible/inventory.ini"
}