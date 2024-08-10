# Specify the AWS provider
provider "aws" {
  region = "eu-central-1" # Change to your preferred region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a" # Change to your preferred availability zone
  map_public_ip_on_launch = true            # automatically assign publlic ip to any ec2 launched in the public subnet


  tags = {
    Name = "public_subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main.id
}

# Create a Security Group that allows SSH and HTTP access
resource "aws_security_group" "frontend-ec2" {
  vpc_id = aws_vpc.main.id

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

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-ec2-sg"
  }
}

resource "aws_key_pair" "aws_frontend_ec2_keypair" {
  key_name   = "aws_frontend_ec2_keypair"
  public_key = file("./ssh_keys/aws_frontend_ec2_keypair.pub")
}

# Create the EC2 instance
resource "aws_instance" "web" {
  ami                    = "ami-07652eda1fbad7432" # Ubuntu AMI for eu-central-1 region
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.frontend-ec2.id]
  key_name               = "aws_frontend_ec2_keypair"

  user_data = <<-EOF
              #!/bin/bash
              # Update the package index
              sudo yum update -y

              # Install Docker
              sudo amazon-linux-extras install docker -y

              # Start Docker service
              sudo service docker start

              # Enable Docker service to start on boot
              sudo systemctl enable docker

              # Add the ec2-user to the docker group so you can execute Docker commands without using sudo
              sudo usermod -a -G docker ec2-user
              EOF

  tags = {
    Name = "FrontendEC2"
  }
}
