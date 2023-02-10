locals {
  project_name = var.project_name
  amazon_host  = "amazon-linux"
  ubuntu_host  = "ubuntu-linux"

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



################## Create Security Group ################## 
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

################## Clean Up Existing Inventory File ################## 
resource "null_resource" "clean_up" {
  provisioner "local-exec" {
    command = "rm -rf ../static_inventory"
  }
}


################## SSH key generation ################## 

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


################## Extracting private key ################## 

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = var.private_key_location
  file_permission = "0600"
}


################## Create AWS key pair ################## 

resource "aws_key_pair" "aws_ec2_access_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

################## Create AWS EC2 Instance with "Amozon linux" AMI ################## 
resource "aws_instance" "amazon_linux_host" {
  count                  = var.amazon_linux_host_count
  ami                    = data.aws_ami.amazon_linux_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.aws_ec2_access_key.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    "Name" = "${local.amazon_host}-${count.index + 1}"
    "OS"   = local.amazon_host
  }

}

################## Create AWS EC2 Instance with "Ubuntu" AMI ################## 
resource "aws_instance" "ubuntu_host" {
  count                  = var.ubuntu_host_count
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.aws_ec2_access_key.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    "Name" = "${local.ubuntu_host}-${count.index + 1}"
    "OS"   = local.ubuntu_host
  }
}

################## Create static inventory ################## 
resource "null_resource" "generate_static_inventory" {
  provisioner "local-exec" {
    command = templatefile("${path.module}/static-inventory-template.tpl", {
      amazon = aws_instance.amazon_linux_host[*].public_ip
      ubuntu = aws_instance.ubuntu_host[*].public_ip
    })
  }

  depends_on = [
    aws_instance.amazon_linux_host,
    aws_instance.ubuntu_host,
  ]
}






