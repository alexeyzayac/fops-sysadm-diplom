resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_openssh
  filename        = "${path.module}/../ssh/cloud-${var.project}"
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content         = tls_private_key.ssh.public_key_openssh
  filename        = "${path.module}/../ssh/cloud-${var.project}.pub"
  file_permission = "0644"
}