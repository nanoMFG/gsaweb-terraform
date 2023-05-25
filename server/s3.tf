resource "aws_s3_bucket" "ansible_bucket" {
  bucket = "${var.name}-${var.env}-ansilbe-bucket"
  acl    = "private"
  
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "${var.name}-${var.env}-ansible-bucket"
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_versioning" "ansible_bucket_versioning" {
  bucket = aws_s3_bucket.ansible_bucket.id
  
  status = "Suspended" // Or "Enalbled" 
}