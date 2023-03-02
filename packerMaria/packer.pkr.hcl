packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
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

variable "ami_users" {
  type = list(string)
  default = ["272647741966"]
}

source "amazon-ebs" "ec2-user" {
  ami_name      = "Mysql-application"
  instance_type = "t2.micro"
  region        = "us-east-1"
  # AMI permissions
  ami_users = ["691032928490","272647741966"]
  ami_regions = ["us-west-2"]
  //source_ami    = "ami-0dfcb1ef8550277af"
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
  name = "Maria-packer"


  sources = [
    "source.amazon-ebs.ec2-user",

  ]

  provisioner "file" {
    source      = "./mysql.service"
    destination = "/tmp/mysql.service"
  }

  provisioner "shell" {

    inline = [

      "sudo yum update -y",
      "sudo yum upgrade -y",
      "sudo amazon-linux-extras install nginx1 -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",


      "sudo yum install -y gcc-c++ make",
      "curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - ",
      "sudo yum install -y nodejs",

      "sudo yum install -y git",
      "git clone https://github.com/Maria-Obono/myappA.git",
      "cd myappA/mysql && npm install",
      #"node server.js"
      "sudo mv /tmp/mysql.service /etc/systemd/system/mysql.service",
      "sudo systemctl enable mysql.service",
      "sudo systemctl start mysql.service",

    ]
    
  }
 
 

}