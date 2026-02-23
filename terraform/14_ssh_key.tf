# 86_ssh_key.tf

# Генерация пары ключей (алгоритм ED25519)
resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

# Сохранение приватного ключа в папку ../ssh/ 
resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_openssh
  filename        = "${path.module}/../ssh/cloud-${var.flow}"
  file_permission = "0600"
}

# Сохранение публичного ключа
resource "local_file" "public_key" {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "${path.module}/../ssh/cloud-${var.flow}.pub"
  file_permission = "0644"
}