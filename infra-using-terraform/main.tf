locals {
  project_name = var.project_name
  amz_host = "amazon-linux"
  ubuntu_host = "ubuntu-linux"
  
  sg_ports = [
    {
      "port" : 22,
      "protocol" : "tcp"
    },
    {
      "port" : -1,
      "protocol" : "icmp"
    },
    {
      "port" : 443,
      "protocol" : "tcp"
    },
    {
      "port" : 80,
      "protocol" : "tcp"
    }
  ]
}

# security group create
resource "aws_security_group" "public_sg" {
  name        = "public_access"
  description = "Allow SSH,PING,HTTP and HTTPS traffic from Anywhere"

  dynamic "ingress" {

    for_each = local.sg_ports
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {

    for_each = local.sg_ports
    content {
      from_port   = egress.value["port"]
      to_port     = egress.value["port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    "Name" = local.project_name
  }
}

# hello
# key_pair create
resource "aws_key_pair" "aws_ec2_access_key" {
  key_name   = "aws-ec2-access"
  public_key = file("~/.ssh/aws-ec2-access.pub")
}

# instance create
resource "aws_instance" "amz_linux2_host" {
  count                  = 2
  ami                    = data.aws_ami.amazon_linux_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.aws_ec2_access_key.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    "Name" = "${local.amz_host}-${count.index + 1}"
    "OS" = local.amz_host
  }
  
 }
 
 resource "aws_instance" "amz_ubuntu_host" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.aws_ec2_access_key.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    "Name" = "${local.ubuntu_host}-${count.index + 1}"
    "OS" = local.ubuntu_host
  }
  
 }