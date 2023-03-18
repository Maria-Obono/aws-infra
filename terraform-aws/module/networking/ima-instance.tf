//resource "aws_key_pair" "TF_key" {
 // key_name   = "TF_key"
 // public_key = tls_private_key.rsa.public_key_openssh
//}
 // resource "tls_private_key" "rsa" {
 // algorithm   = "RSA"
 // rsa_bits = 4096
  
//}
 //resource "local_file" "TF-key" {
  //content   = tls_private_key.rsa.private_key_pem
  //filename = "tfkey"
  
//}


resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  vpc_id = aws_vpc.maria.id
  description = "allow on port 443, 80, and 22"

  
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

   ingress {
    description      = "NODEAPP"
    from_port        = 5050
    to_port          = 5050
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }


ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    //cidr_blocks      = ["${var.my_ip}/32"]
    cidr_blocks = [ "0.0.0.0/0" ]
   
  }

  ingress {
    description      = "All TCP"
    from_port        = 0
    to_port          = 655
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  tags = {
    Name = "Terraform_SG"
  }
}
data "aws_ami" "app_ami" {
  executable_users = [ "272647741966" , "self"]
  most_recent      = true
  name_regex       = "-*"
  //owners           = ["self"]
   
  
  
}



resource "aws_instance" "web_application" {
  count = var.settings.web_app.count
  instance_type          = var.settings.web_app.instance_type
  ami                    = data.aws_ami.app_ami.id
  subnet_id = aws_subnet.public-subnet[count.index].id
  iam_instance_profile = aws_iam_instance_profile.maria_profile.id

  //key_name = aws_key_pair.TF_key.key_name
  key_name = "Key"

  user_data = <<-EOF
              #!/bin/bash

              sudo yum update -y
              sudo yum install httpd -y
              sudo service httpd start

              cd /home/ec2-user/Application
              
              echo "HOST_DB=\${aws_db_instance.database-instance.address}" >> .env
              echo "BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket}" >> .env
              echo "AWS_ACCESS_KEY=AKIAT66YSMIHLIFBA3JD" >> .env
              echo "USER_DB=csye6225" >> .env
              echo "PASSWORD_DB=MariaGloria1" >> .env
              echo "DB_NAME=csye6225" >> .env

              sudo systemctl stop mysql.service
              sudo systemctl restart mysql.service

              EOF
  
  vpc_security_group_ids = [aws_security_group.app_sg.id]
   
disable_api_termination = false // Set this to false to disable protection against accidental termination
associate_public_ip_address = true

  root_block_device {
    volume_size = 50             // Set the root volume size to 50GB
    volume_type = "gp2"          // Set the root volume type to gp2
  }

   tags = {
      "Name" = "Terraform EC2_${count.index}"
       vpc_id      = aws_vpc.maria.id
       role       = aws_iam_role.EC2-CSYE6225.name

    }



}

 