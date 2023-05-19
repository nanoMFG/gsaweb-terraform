output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}
output "private_key_pem" {
  description = "The private key in PEM format"
  value       = tls_private_key.key.private_key_pem
  sensitive   = true
}