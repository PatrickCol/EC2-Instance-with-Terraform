provider "aws" {
    region = "us-east-1" 
}

resource "aws_security_group" "ec2_sg" {
    name        = "ec2_security_group"
    description = "Permite el trafico por SSH and HTTP"

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

data "aws_ami" "cloud9_ubuntu22" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*Cloud9Ubuntu22*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}


resource "aws_instance" "ec2_instance" {
    ami           = data.aws_ami.cloud9_ubuntu22.id
    instance_type = "t2.micro"

    key_name               = "vockey"
    security_groups        = [aws_security_group.ec2_sg.name]

    root_block_device {
        volume_size = 20
        volume_type = "gp2"
    }

    tags = {
        Name = "Cloud9Ubuntu22-Instance-Terraform"
    }
}