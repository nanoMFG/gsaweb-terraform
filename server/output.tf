# output "instance_public_ip" {
#   value       = aws_instance.web.public_ip
#   description = "Public IP of the EC2 instance"
# }
output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
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
  description = "The name of the bucket used by ansible"
  value = aws_s3_bucket.ansible_bucket.id
}
output "app_prefix" {
  description = "The prefix of the application. Used by ansible to target the correct instances."
  value = "${var.name}_${var.env}"
}
output "env" {
  description = "The environment of the application."
  value = var.env
}