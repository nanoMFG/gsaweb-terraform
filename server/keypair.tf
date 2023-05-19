resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated_key" {
  key_name   = "generated-key"
  public_key = tls_private_key.key.public_key_openssh
}