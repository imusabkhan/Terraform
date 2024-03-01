provider "aws" {
  region = "ap-southeast-1"
}

# Create VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ExampleVPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create Route Table
resource "aws_route_table" "example_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }
}

# Create Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "example_route_association" {
  subnet_id      = aws_subnet.example_subnet.id
  route_table_id = aws_route_table.example_route_table.id
}

# Create custom security group
resource "aws_security_group" "custom_security_group" {
  name        = "allow-all"
  description = "Security group allowing SSH and HTTP access for all users"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Authentication"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Web Server"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Generate SSH key pair
resource "tls_private_key" "tf-rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf-keys" {
  key_name   = "tf-keys"
  public_key = tls_private_key.tf-rsa.public_key_openssh
}

# Create EC2 instance
resource "aws_instance" "Docker_Terraform" {
  ami                         = "ami-0fa377108253bf620"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.example_subnet.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.tf-keys.key_name # Use the key name generated by Terraform

  vpc_security_group_ids = [
    aws_security_group.custom_security_group.id,
  ]

  tags = {
    "Name" = "Docker-Project"
  }

  provisioner "file" {
    source      = "/Users/musabkhan/Desktop/Musab/Learning/Terraform/Amazon-Resources/Project/install.sh"
    destination = "/tmp/install.sh"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu" # Assuming Ubuntu AMI
    host        = self.public_ip
    private_key = tls_private_key.tf-rsa.private_key_pem
    timeout     = "1m"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "bash /tmp/install.sh"
    ]
  }
}