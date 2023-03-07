packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type    = string
  default = "packer-aws-amazon-linux"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "my_ec2" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
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
  ssh_username = "ec2-user"
}

build {
  name    = "packer-ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu_java"
  ]

  provisioner "file" {
    source = "./myappA.zip"
    destination = "/home/ec2-user/myappA.zip"
  },

  provisioner "file" {
    source = "./myappA/mysql.service"
    destination = "/tmp/myappA/mysql.service"
  }

  provisioner "shell" {

    inline = [
      # Install MySQL client
        
        "sudo yum update"
        "sudo yum install -y mysql-client"
        "export DB_HOST=<your RDS endpoint>",
        "export DB_USER=<your database username>",
        "export DB_PASSWORD=<your database password>",
        "export DB_NAME=<your database name>",
        "mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -D $DB_NAME -e \"SELECT 1;\""
        
    ]
  },

  provisioner "shell" {
    script= "./app.sh"
  }
}
