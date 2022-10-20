# resource "aws_launch_configuration" "terramino" {
#   name_prefix     = "learn-terraform-aws-asg-"
#   image_id        = var.instance_ami
#   instance_type   = var.instance_type
#   user_data       = file("user-data.sh")
#   security_groups = [aws_security_group.sg.id] 

#   lifecycle {
#     create_before_destroy = true
#   }
# }
