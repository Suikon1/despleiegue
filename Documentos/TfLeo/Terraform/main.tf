provider "aws" {
  region = "us-east-1"
}

# Corrected data source - should be "aws_vpc" not "aws-vpc"
data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "ec2_api_rest_tf" {
  ami           = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  key_name      = "terraform-trackdevops"
  
  # Use vpc_security_group_ids instead of security_groups for VPC instances
  vpc_security_group_ids = [aws_security_group.ag_api_rest_tf.id]
  
  # Get a subnet from the default VPC dynamically
  subnet_id = data.aws_subnet.default.id
  
  tags = {
    Name = "API_REST_TERRAFORM_V1" # Changed from key_name to Name
  }
}

# Add data source to get a subnet from the default VPC
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a" # You can change this to your preferred AZ
  default_for_az    = true
}

resource "aws_security_group" "ag_api_rest_tf" {
  name        = "sg_api_rest_tf"
  description = "Este es el grupo de seguridad"
  vpc_id      = data.aws_vpc.default.id
  
  tags = {
    Name = "sg_api_rest_tf" # Changed from name to Name
  }
  
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