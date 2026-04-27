# VPC
resource "yandex_vpc_network" "develop" {
  name = "${var.network_name}-${var.project}"
}

# Опциональный NAT-шлюз и таблица маршрутизации
resource "yandex_vpc_gateway" "nat_gateway" {
  count = var.create_nat_gateway ? 1 : 0

  name = "gateway-${var.project}"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "public_rt" {
  count      = var.create_nat_gateway ? 1 : 0
  name       = "public-rt-${var.project}"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway[0].id
  }
}

# Подсети создаются по карте var.subnets
resource "yandex_vpc_subnet" "this" {
  for_each = var.subnets

  name           = "${each.key}-${var.project}"          # например, subnet_a-zayac-02-2026
  zone           = each.value.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = [each.value.cidr]

  # Если NAT включён, присоединяем таблицу маршрутизации
  route_table_id = var.create_nat_gateway ? yandex_vpc_route_table.public_rt[0].id : null
}