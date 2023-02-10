variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "Ansible-Dynamic-Inventory"
}

variable "instance_type" {
  description = "Name of the project"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "aws-ec2-access"
}

variable "amazon_linux_host_count" {
  description = "Number of amazon linux host"
  type        = number
  default     = 2
}

variable "ubuntu_host_count" {
  description = "Number of ubuntu host"
  type        = number
  default     = 2
}

variable "private_key_location" {
  description = "Location of the private key"
  type        = string
  default     = "/home/ec2-user/.ssh/aws-ec2-access.pem"
}


