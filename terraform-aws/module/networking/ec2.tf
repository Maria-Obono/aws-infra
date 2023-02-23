#Terraform Instance
resource "aws_instance" "myweb" {
    ami = "ami-0e7108e2f163a4ebf" #amazon Linux 2 AMI
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private-subnet1.id
    vpc_security_group_ids =  [aws_security_group.Terraform_SG.id]
    //key_name = "tfkey"

  
 disable_api_termination = false // Set this to false to disable protection against accidental termination

  root_block_device {
    volume_size = 50             // Set the root volume size to 50GB
    volume_type = "gp2"          // Set the root volume type to gp2
  }

    tags = {
      "Name" = "Terraform EC2"
      desable_api_termination= false
      
      
    }
}



output "public_ipv4_address" {
  value = aws_instance.myweb.public_ip
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

#security group
resource "aws_security_group" "Terraform_SG" {
  name        = "SecurityG.T"
  description = "security group for terraform"
  vpc_id      = aws_vpc.maria.id

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


