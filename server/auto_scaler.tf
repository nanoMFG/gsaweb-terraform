# resource "aws_launch_template" "ecs" {
#   count         = var.aws_auto_scaler ? 1 : 0
#   name_prefix   = "${var.name}_${var.env}_"
#   image_id      = var.instance_ami
#   instance_type = length(var.instance_types) == 0 ? "t3.micro" : var.instance_types[0]

#   vpc_security_group_ids = [aws_security_group.sg.id]

# #   user_data = base64encode(data.template_file.userdata[0].rendered)
#   user_data = <<-EOF
#   #!/bin/bash
#   echo "*** Installing apache2"
#   sudo apt update -y
#   sudo apt install apache2 -y
#   echo "*** Completed Installing apache2"
#   EOF

#   key_name = module.key_pair.key_pair_name

#   lifecycle {
#     create_before_destroy = true
#   }
    
#   tags = {
#     Name = "${var.name}_${var.env}_launch_template"
#   }

# }
# # resource "aws_launch_configuration" "terramino" {
# #   name_prefix     = "learn-terraform-aws-asg-"
# #   image_id        = var.instance_ami
# #   instance_type   = var.instance_type
# #   user_data       = file("user-data.sh")
# #   security_groups = [aws_security_group.sg.id] 
# #   count = var.aws_auto_scaler ? 1 : 0
#   lifecycle {
#     create_before_destroy = true
#   }
# }
