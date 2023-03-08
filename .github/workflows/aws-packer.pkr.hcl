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

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "my_ec2" {
  ami_name      = "packer-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "${var.aws_region}"
  ami_users     = ["272647741966"]
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-2.*.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"


}

build {
  name = "packer-ec2"
  sources = [
    "source.amazon-ebs.my_ec2"
  ]

  provisioner "file" {
    source      = "../../mysql.zip"
    destination = "/home/ec2-user/mysql.zip"
  }

  provisioner "file" {
    source      = "./mysql.service"
    destination = "/tmp/mysql.service"
  }

  provisioner "shell" {

    inline = [
      "sudo yum update -y",

      "sudo yum install -y gcc-c++ make",
      "curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -",
      "sudo yum install -y nodejs",

      "sudo yum install unzip -y",
      "cd ~/ && unzip mysql.zip",
      "cd ~/ mysql && npm i --only=prod",

      "sudo mv /tmp/mysql.service /etc/systemd/system/mysql.service",
      "sudo systemctl enable mysql.service",
      "sudo systemctl start mysql.service",

    ]
  }

  // provisioner "shell" {
  //  script= "./app.sh"
  // }
}
