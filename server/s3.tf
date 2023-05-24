resource "aws_s3_bucket" "ansible_bucket" {
  bucket = "${var.name}-${var.env}-ansilbe-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }
  
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.name}-${var.env}-ansilbe-bucket"
    Environment = "${var.env}"
  }
}