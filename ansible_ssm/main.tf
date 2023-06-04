# Creates a new S3 bucket which will be used to store Ansible files.
resource "aws_s3_bucket" "ansible_bucket" {
  count = var.create_ansible_resources ? 1 : 0

  bucket = "${var.name}-${var.env}-ansible-bucket"
  
  # Allows to delete S3 bucket, even if it's not empty.
  force_destroy = true

  tags = {
    Name        = "${var.name}-${var.env}-ansible-bucket"
    Environment = "${var.env}"
  }
}

# Defines the ownership controls for the Ansible S3 bucket.
# Setting the object ownership to "ObjectWriter" means that new objects 
# uploaded to the bucket and their future permissions are controlled by 
# the object writer.
resource "aws_s3_bucket_ownership_controls" "ansible_bucket_ownership_controls" {
  count = var.create_ansible_resources ? 1 : 0

  bucket = aws_s3_bucket.ansible_bucket.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

# Sets the Access Control List (ACL) for the Ansible S3 bucket to "private".
# This means that only the AWS account that created the bucket can access it.
resource "aws_s3_bucket_acl" "ansible_bucket_acl" {
  count = var.create_ansible_resources ? 1 : 0

  bucket = aws_s3_bucket.ansible_bucket.id
  acl    = "private"
  
  # Ensures that the ownership controls are set before applying the ACL.
  depends_on = [
    aws_s3_bucket_ownership_controls.ansible_bucket_ownership_controls
  ]
}

# Enables versioning for the Ansible S3 bucket.
# This allows you to preserve, retrieve, and restore every version of 
# every object in the bucket, which protects from both unintended 
# user actions and application failures.
resource "aws_s3_bucket_versioning" "ansible_bucket_versioning" {
  count = var.create_ansible_resources ? 1 : 0

  bucket = aws_s3_bucket.ansible_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Defines a variable to control whether to create the resources.
variable "create_ansible_resources" {
  description = "Whether to create the AWS resources"
  type        = bool
  default     = false
}

# Defines a variable to be used as the name in the resource tags
variable "name" {
  description = "Project name"
  type        = string
  default     = "gsaweb"
}

# Defines a variable to be used as the environment in the resource tags
variable "env" {
  description = "Project environment such as dev, qa or prod"
  type        = string
}

output "ansible_bucket_name" {
  description = "The name of the bucket used by ansible"
  value = aws_s3_bucket.ansible_bucket.id
}