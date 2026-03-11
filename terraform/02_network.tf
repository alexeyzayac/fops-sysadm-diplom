# 02_network.tf

# Облачная сеть
resource "yandex_vpc_network" "develop" {
  name = "develop-fops-${var.flow}"
}

# NAT-шлюз для доступа в интернет (используется всеми подсетями)
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.flow}"
  shared_egress_gateway {}
}

# Таблица маршрутизации для всех подсетей (выход в интернет через NAT)
resource "yandex_vpc_route_table" "public_rt" {
  name       = "public-route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Подсеть в зоне ru-central1-a (используется для веб-сервера nginx-1 и ALB)
resource "yandex_vpc_subnet" "subnet_a" {
  name           = "subnet-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.1.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

# Подсеть в зоне ru-central1-b (используется для веб-сервера nginx-2 и ALB)
resource "yandex_vpc_subnet" "subnet_b" {
  name           = "subnet-${var.flow}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.2.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

# Подсеть в зоне ru-central1-d (используется для Zabbix, Kibana, Elasticsearch, Bastion)
resource "yandex_vpc_subnet" "subnet_d" {
  name           = "subnet-${var.flow}-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.3.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}