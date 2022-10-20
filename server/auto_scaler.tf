# resource "aws_launch_configuration" "terramino" {
#   name_prefix     = "learn-terraform-aws-asg-"
#   image_id        = data.aws_ami.amazon-linux.id
#   instance_type   = "t2.micro"
#   user_data       = file("user-data.sh")
#   security_groups = [aws_security_group.terramino_instance.id]

#   lifecycle {
#     create_before_destroy = true
#   }
# }
