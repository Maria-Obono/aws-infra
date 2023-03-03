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
  ami_users = ["272647741966"]
  ami_regions = ["us-east-1"]
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
    source = "./webapp-main.zip"
    destination = "/home/ec2-user/webapp-main.zip"
  }

  provisioner "file" {
    source = "./webapp-main.service"
    destination = "/tmp/webapp-main.service"
  }

  provisioner "shell" {
    script = "./app.sh"
  }

  #provisioner "shell" {

   # inline = [

     # "sudo yum update -y",
     # "sudo yum upgrade -y",
     # "sudo amazon-linux-extras install nginx1 -y",
     # "sudo systemctl enable nginx",
      #"sudo systemctl start nginx",


      #"sudo yum install -y gcc-c++ make",
      #"curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash - ",
      #"sudo yum install -y nodejs",

      #"sudo yum install -y git",
      #"git clone https://github.com/Maria-Obono/webapp.git",

#"sudo yum install unzip -y",
#"cd && unzip webapp-main.zip",


     # "cd /webapp-main && npm install",
      
     # "sudo mv /tmp/webapp-main.service /etc/systemd/system/webapp-main.service",
     # "sudo systemctl enable webapp-main.service",
      #"sudo systemctl start webapp-main.service",

    #]
    
 # }

 post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      iteration_id = packer.iterationID
    }
  }
 
 

}