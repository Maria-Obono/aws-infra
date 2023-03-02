resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  vpc_id = aws_vpc.maria.id
  description = "allow on port 5050, 443, 80, and 22"

  ingress {
    from_port        = 5050
    to_port          = 5050
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "All TCP"
    from_port        = 0
    to_port          = 655
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "Terraform_SG"
  }
}

data "aws_ami" "app_ami" {
  most_recent      = true
  name_regex       = "-*"
  owners           = ["self"]
}

resource "aws_instance" "web_app" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.app_ami.id
  subnet_id = aws_subnet.public-subnet1.id
  
  vpc_security_group_ids = [aws_security_group.app_sg.id]

disable_api_termination = false // Set this to false to disable protection against accidental termination
associate_public_ip_address = true

  root_block_device {
    volume_size = 50             // Set the root volume size to 50GB
    volume_type = "gp2"          // Set the root volume type to gp2
  }

   tags = {
      "Name" = "Terraform EC2"
       vpc_id      = aws_vpc.maria.id
    }

}

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}
  resource "tls_private_key" "rsa" {
  algorithm   = "RSA"
  rsa_bits = 4096
  
}
 resource "local_file" "TF-key" {
  content   = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
  
}