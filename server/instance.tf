resource "aws_iam_instance_profile" "ssm" {
  name = "ssm"
  role = aws_iam_role.ssm.name
}

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

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  iam_instance_profile   = aws_iam_instance_profile.ssm.name

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  #subnet_id              = aws_subnet.public_subnet.id
  subnet_id = aws_subnet.private_subnet.id
  user_data = <<-EOF
              #!/bin/bash
              sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent.service
              sudo apt update -y
              sudo apt install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              sudo apt install -y git
              echo "Creating .bashrc for root"
              touch /root/.bashrc
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
              echo "Waiting for NVM installation to finish..."
              sleep 10
              export NVM_DIR="$HOME/.nvm"
              export NODE_OPTIONS="--max-old-space-size=4096 --openssl-legacy-provider"
              [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
              [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
              nvm install node
              git clone https://github.com/nanoMFG/gsa-webapp-frontend-c3ai.git
              cd gsa-webapp-frontend-c3ai
              npm install
              npm run build
              sudo cp -r build/* /var/www/html
              sudo chown -R www-data:www-data /var/www/html
              sudo systemctl restart apache2
              EOF


   tags = {
    Name = "${var.name}_${var.env}_web_instance"
  }

  volume_tags = {
    Name = "${var.name}_${var.env}_web_instance"
  } 

}
