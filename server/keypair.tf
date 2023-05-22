# resource "tls_private_key" "key" {
#   algorithm = "RSA"
# }

# resource "aws_key_pair" "generated_key" {
#   key_name   = "generated-key"
#   public_key = tls_private_key.key.public_key_openssh
# }

# output "private_key_pem" {
#   description = "The private key in PEM format"
#   value       = tls_private_key.key.private_key_pem
#   sensitive   = true
# }
