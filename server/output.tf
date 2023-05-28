# output "instance_public_ip" {
#   value       = aws_instance.web.public_ip
#   description = "Public IP of the EC2 instance"
# }
output "instance_id" {
  description = "The ID of the created instance"
  value       = aws_instance.web.id
}
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.web.dns_name
}
output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.cert.arn
}
output "ansible_bucket_name" {
  value = aws_s3_bucket.ansible_bucket.id
}
output "app_prefix" {
  value = "${var.name}_${var.env}"
}
