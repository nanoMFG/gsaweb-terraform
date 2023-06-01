# IAM instance profile for AWS Systems Manager (SSM), allowing SSM actions on instances.
resource "aws_iam_instance_profile" "ssm" {
  name = "ssm"
  role = aws_iam_role.ssm.name
}

# IAM role for SSM, with policy allowing EC2 instances to assume this role.
resource "aws_iam_role" "ssm" {
  name = "ssm"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

# Attaches the 'AmazonSSMManagedInstanceCore' policy to the 'ssm' role, enabling SSM communication.
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Defines an EC2 instance, specifying the AMI, instance type, IAM profile, security group, subnet, and a user data script.
resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ssm.name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id = aws_subnet.private_subnet.id
  depends_on = [aws_nat_gateway.nat]
  user_data = <<-EOF
              #!/bin/bash
              
              # Retry until we can successfully make a request to the internet
              until curl -sfI https://www.google.com; do
                  echo "Waiting for internet connectivity..."
                  sleep 5
              done
              EOF

   tags = {
    Name = "${var.name}_${var.env}_web_instance"
  }

  volume_tags = {
    Name = "${var.name}_${var.env}_web_instance"
  } 

}
