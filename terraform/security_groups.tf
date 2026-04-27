resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg-${var.project}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "SSH from internet"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Any outgoing"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.project}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description       = "HTTP from ALB"
    protocol          = "TCP"
    port              = 80
    security_group_id = yandex_vpc_security_group.alb_sg.id
  }

  ingress {
    description       = "Zabbix agent from Zabbix server"
    protocol          = "TCP"
    port              = 10050
    security_group_id = yandex_vpc_security_group.zabbix_sg.id
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Any outgoing"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "alb_sg" {
  name       = "alb-sg-${var.project}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "HTTP from internet"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Health checks from ALB infrastructure"
    protocol       = "TCP"
    port           = 30080
    v4_cidr_blocks = ["198.18.235.0/24", "198.18.248.0/24"]
  }

  egress {
    description    = "To web servers on port 80"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = [
      yandex_vpc_subnet.this["subnet_a"].v4_cidr_blocks[0],
      yandex_vpc_subnet.this["subnet_b"].v4_cidr_blocks[0]
    ]
  }
}

resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name       = "elasticsearch-sg-${var.project}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description       = "Elasticsearch API from Kibana"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.kibana_sg.id
  }

  ingress {
    description       = "Elasticsearch API from Filebeat (web servers)"
    protocol          = "TCP"
    port              = 9200
    security_group_id = yandex_vpc_security_group.web_sg.id
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Any outgoing"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg-${var.project}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Kibana web interface (public)"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Any outgoing"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg-${var.project}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Zabbix web frontend (public)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Zabbix server port (agents connect to 10051)"
    protocol    = "TCP"
    port        = 10051
    v4_cidr_blocks = [
      yandex_vpc_subnet.this["subnet_a"].v4_cidr_blocks[0],
      yandex_vpc_subnet.this["subnet_b"].v4_cidr_blocks[0]
    ]
  }

  ingress {
    description       = "SSH from bastion"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion_sg.id
  }

  egress {
    description    = "Any outgoing"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

