output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the EC2 instance"
}
output "instance_id" {
  description = "The ID of the created instance"
  value       = aws_instance.web.id
}