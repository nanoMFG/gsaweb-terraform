resource "aws_s3_bucket" "ansible_bucket" {
  bucket = "${var.name}-${var.env}-ansilbe-bucket"
  
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.name}-${var.env}-ansible-bucket"
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_acl" "ansible_bucket_acl" {
  bucket = aws_s3_bucket.ansible_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "ansible_bucket_versioning" {
  bucket = aws_s3_bucket.ansible_bucket.id
  
  status = "Suspended"
}