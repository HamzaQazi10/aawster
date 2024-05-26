# Specify the provider
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# Define the EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0bb84b8ffd87024d8"  # Change to your desired AMI ID
  instance_type = "t2.micro"

  # Add tags to your instance
  tags = {
    Name = "MyFirstInstance"
  }

  # Define a security group inline
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  # Define the key pair for SSH access
  key_name = "hamzaworkerNViginia"  # Change to your key pair name

  # Add a user data script
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}

# Create a security group
resource "aws_security_group" "instance" {
  name        = "terraform-example-instance"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define an output for the public IP
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}
