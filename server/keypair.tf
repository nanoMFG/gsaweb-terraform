resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.key.public_key_openssh
}
resource "local_file" "private_key" {
  sensitive_content = tls_private_key.key.private_key_pem
  filename          = "${path.module}/private_key.pem"
}