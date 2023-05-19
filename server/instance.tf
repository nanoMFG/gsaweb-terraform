resource "aws_instance" "web" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.public_subnet.id

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo yum install -y git
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
              . ~/.nvm/nvm.sh
              nvm install node
              git clone https://github.com/nanoMFG/gsa-webapp-frontend-c3ai.git
              cd your-react-repo
              npm install
              npm run build
              sudo cp -r build/* /var/www/html
              sudo chown -R apache:apache /var/www/html
              sudo systemctl restart httpd
              EOF
}
