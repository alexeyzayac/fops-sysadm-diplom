#cloud-config

datasource:
  Ec2:
    strict_id: false

ssh_pwauth: no

users:
  - name: localadmin
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${public_key}

packages:
  - curl
  - docker.io
  - nginx

runcmd:
  # Обновление системы
  - apt update && apt -y full-upgrade

  # Установка Zabbix-agent
  - wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu24.04_all.deb
  - dpkg -i zabbix-release_latest_7.4+ubuntu24.04_all.deb
  - apt update
  - apt install -y zabbix-agent

  # Запуск и включение сервисов
  - systemctl enable --now docker nginx
  - systemctl restart docker nginx