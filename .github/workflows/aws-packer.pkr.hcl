packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
variable "ami_users" {
  type = list(string)
  default = ["272647741966"]
}

source "amazon-ebs" "Mysql" {

  access_key =  "AKIA2BZGFWDVEHXZ5BUA"
  secret_key = "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"
  region         = "us-east-1"
  ami_name = "mysql-app-${local.timestamp}"
  ami_users = ["272647741966"]

  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  # source_ami = "ami-013a129d325529d4d"


  instance_type = "t2.micro"
  //region        = "us-east-1"
  ssh_username  = "ec2-user"
}

build {
  sources = [
    "source.amazon-ebs.Mysql"
  ]

  provisioner "file" {
    source      = "./mysql.zip"
    destination = "/home/ec2-user/mysql.zip"
  }

  provisioner "file" {
    source      = "./mysql.service"
    destination = "/tmp/mysql.service"
  }


  provisioner "shell" {
    script = "./app.sh"
    
  }
}
