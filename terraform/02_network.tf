# 02_network.tf

# Облачная сеть
resource "yandex_vpc_network" "develop" {
  name = "develop-fops-${var.flow}"
}

# NAT-шлюз для публичных подсетей
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "fops-gateway-${var.flow}"
  shared_egress_gateway {}
}

# Таблица маршрутизации для публичных подсетей (доступ в интернет)
resource "yandex_vpc_route_table" "public_rt" {
  name       = "public-route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Таблица маршрутизации для приватных подсетей (доступ в интернет, без публичных IP)
resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-route-table-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Публичные подсети (с интернетом) - a
resource "yandex_vpc_subnet" "public_a" {
  name           = "public-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.1.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

# Публичные подсети (c интернетом) - b
resource "yandex_vpc_subnet" "public_b" {
  name           = "public-${var.flow}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.2.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

# Публичные подсети (с интернетом) - d
resource "yandex_vpc_subnet" "public_d" {
  name           = "public-${var.flow}-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.10.3.0/24"]
  route_table_id = yandex_vpc_route_table.public_rt.id
}

# Приватные подсети (только локальные маршруты VPC) - a
resource "yandex_vpc_subnet" "private_a" {
  name           = "private-${var.flow}-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.20.1.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Приватные подсети (только локальные маршруты VPC) - b
resource "yandex_vpc_subnet" "private_b" {
  name           = "private-${var.flow}-ru-central1-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.20.2.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Приватные подсети (только локальные маршруты VPC) - d
resource "yandex_vpc_subnet" "private_d" {
  name           = "private-${var.flow}-ru-central1-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.20.3.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}