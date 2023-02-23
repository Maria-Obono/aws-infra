packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "source_ami" {
  type    = string
  default = "ami-0dfcb1ef8550277af"
}

variable "ssh_username" {
  type    = string
  default = "ec2-user"
}




source "amazon-ebs" "ec2-user" {
  ami_name      = "Maria-aws-rr"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0dfcb1ef8550277af"
  ssh_username  = "ec2-user"
 
}



build {
  name = "Maria-packer"


  sources = [
    "source.amazon-ebs.ec2-user",
  ]
provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "CHECKPOINT_DISABLE=1"
    ]
    inline = [
"sudo yum update -y"
"sudo yum install -y mysql-server"

    ]
  }
  
}