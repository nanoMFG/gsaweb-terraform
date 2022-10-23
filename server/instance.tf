resource "aws_instance" "instance" {
  ami             = var.instance_ami
  instance_type   = var.instance_type
  key_name        = module.key_pair.key_pair_name
  subnet_id       = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  count = var.aws_instance ? 1 : 0

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  echo "*** Completed Installing apache2"
  EOF

  tags = {
    Name = "${var.name}_${var.env}_web_instance"
  }

  volume_tags = {
    Name = "${var.name}_${var.env}_web_instance"
  } 
}
