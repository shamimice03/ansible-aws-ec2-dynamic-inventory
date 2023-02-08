data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-kernel-*-hvm-*-x86_64-gp2"
    ]
  }
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-*-amd64-server-*"
    ]
  }
}
