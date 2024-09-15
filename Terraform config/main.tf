# main.tf

provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "blog_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.blog_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "blog_igw" {
  vpc_id = aws_vpc.blog_vpc.id
}

# Create a route table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.blog_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.blog_igw.id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Create a security group to allow SSH and HTTP access
resource "aws_security_group" "blog_web_sg" {
  vpc_id = aws_vpc.blog_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# Launch an EC2 instance
resource "aws_instance" "blog_web_server" {
  ami                    = "ami-0e86e20dae9224db8" # Amazon Ubuntu 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id # Reference the Terraform-created subnet
  vpc_security_group_ids = [aws_security_group.blog_web_sg.id]
  associate_public_ip_address = true
  key_name = "blogwebsite-key-1"

  # Use a startup script to install Docker
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              EOF

  tags = {
    Name = "NodeAppServer"
  }
}

# Output the public IP of the instance
output "instance_ip" {
  value = aws_instance.blog_web_server.public_ip
}

