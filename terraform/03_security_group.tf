# 03_security_group.tf

# Настройка сервера bastion
resource "yandex_vpc_security_group" "bastion_sg" {
  name       = "bastion-sg-${var.flow}"
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

# Настройка серверов nginx
resource "yandex_vpc_security_group" "web_sg" {
  name       = "web-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "HTTP from ALB"
    protocol       = "TCP"
    port           = 80
    security_group_id = yandex_vpc_security_group.alb_sg.id
  }

  ingress {
    description    = "Zabbix agent from Zabbix server"
    protocol       = "TCP"
    port           = 10050
    security_group_id = yandex_vpc_security_group.zabbix_sg.id
  }

  ingress {
    description    = "SSH from bastion"
    protocol       = "TCP"
    port           = 22
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

# Настройка сервера Elasticsearch
resource "yandex_vpc_security_group" "elasticsearch_sg" {
  name       = "elasticsearch-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description          = "Elasticsearch API from Kibana"
    protocol             = "TCP"
    port                 = 9200
    security_group_id = yandex_vpc_security_group.kibana_sg.id
  }

  ingress {
    description          = "Elasticsearch API from Filebeat (web servers)"
    protocol             = "TCP"
    port                 = 9200
    security_group_id = yandex_vpc_security_group.web_sg.id
  }

  ingress {
    description    = "SSH from bastion"
    protocol       = "TCP"
    port           = 22
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

# Настройка сервера Kibana 
resource "yandex_vpc_security_group" "kibana_sg" {
  name       = "kibana-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Kibana web interface (public)"
    protocol       = "TCP"
    port           = 5601
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "SSH from bastion"
    protocol       = "TCP"
    port           = 22
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

# Настройка сервера Zabbix 
resource "yandex_vpc_security_group" "zabbix_sg" {
  name       = "zabbix-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "Zabbix web frontend (public)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "Zabbix server port (agents connect to 10051)"
    protocol       = "TCP"
    port           = 10051
    security_group_id = yandex_vpc_security_group.web_sg.id
  }

  ingress {
    description    = "SSH from bastion"
    protocol       = "TCP"
    port           = 22
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

# Настройка балансировщика Application Load Balancer
resource "yandex_vpc_security_group" "alb_sg" {
  name       = "alb-sg-${var.flow}"
  network_id = yandex_vpc_network.develop.id

  ingress {
    description    = "HTTP from internet"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "To web servers on port 80 (private subnets)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["10.20.1.0/24", "10.20.2.0/24"]
  }
}