# Should maintain a privte key in the remote state file
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"

  key_name           = "gsaweb-${var.env}-key"
  create_private_key = true
}
