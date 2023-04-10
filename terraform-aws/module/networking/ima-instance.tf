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

# Define the load balancer security group
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  vpc_id      = aws_vpc.maria.id
  description = "allow TCP traffic on ports 80 and 443 from anywhere"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LoadBalancer_SG"
  }
}
resource "aws_security_group_rule" "egress_alb_eg2_traffic" {
  type                     = "egress"
  from_port                = 5050
  to_port                  = 5050
  protocol                 = "tcp"
  security_group_id        = aws_security_group.load_balancer_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}
resource "aws_lb" "load_balancer" {
  name               = "web-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  security_groups    = [aws_security_group.load_balancer_sg.id]
 
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = "WebApp"
    Environment = "production"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "my-target-group"
  port        = 5050
  protocol    = "HTTP"
  vpc_id      = aws_vpc.maria.id
  target_type = "instance"

    health_check {
      enabled             = true
      port               ="5050"
      protocol            = "HTTP"
      path                = "/healthz"
      matcher             = "200-399"
      timeout             = 10
      unhealthy_threshold = 2
      healthy_threshold   = 2
      interval            = 30

  }
  depends_on = [
    aws_lb.load_balancer
  ]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Terraform Target Group"
  }
}



//resource "aws_lb_target_group_attachment" "asg_attachment" {
 // count = length(aws_autoscaling_group.web_app_asg)
 // target_group_arn = aws_lb_target_group.target_group.arn
 // target_id        = aws_autoscaling_group.web_app_asg[count.index].id
 // port             = 5050
  // lifecycle {
  //  create_before_destroy = true
  //}
//}


resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port =80
  protocol = "HTTP"
  default_action {
    type= "redirect"

    redirect {
      port = 443
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

# Create a listener to accept HTTP traffic and forward it to instances on port 5050
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.api.arn


  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
    
  }
  depends_on = [aws_acm_certificate_validation.api]
}

output "custom_domain" {
  value = "https://${aws_acm_certificate.api.domain_name}/ping"
}

//EC2 security group
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  vpc_id = aws_vpc.maria.id
  description = "allow on port 443, 80, and 22"
  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
   security_groups = [aws_security_group.load_balancer_sg.id]
    
  }

  ingress {
    description      = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

   ingress {
    description      = "NODEAPP"
    from_port        = 5050
    to_port          = 5050
    protocol         = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
   
  }

ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
   
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

//resource "aws_instance" "web_application" {
  //count = var.settings.web_app.count
  //instance_type          = var.settings.web_app.instance_type
  //ami                    = data.aws_ami.app_ami.id
  //subnet_id = aws_subnet.public-subnet[count.index].id
  //iam_instance_profile = aws_iam_instance_profile.maria_profile.id
  resource "aws_launch_template" "app_launch_template" {
  name = "app_launch_template"
  image_id = data.aws_ami.app_ami.id
  instance_type = var.settings.web_app.instance_type
  
  
  //key_name = aws_key_pair.TF_key.key_name
  key_name = "Key"
  //vpc_security_group_ids = [aws_security_group.app_sg.id]

  placement {
    availability_zone = data.aws_availability_zones.available.names[0]
  }
    network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    subnet_id       = aws_subnet.public-subnet[0].id
    security_groups = [aws_security_group.app_sg.id]
    
  }

  
  iam_instance_profile {
   arn= aws_iam_instance_profile.maria_profile.arn
  }

  user_data = base64encode( <<EOF

 #!/bin/bash
 sudo yum update -y

wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
sudo cp /tmp/cloudwatch-agent-config.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s
sudo service amazon-cloudwatch-agent start

sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl start amazon-cloudwatch-agent

 sudo yum install httpd -y
 sudo service httpd start

  cd /home/ec2-user/Application
              
  echo "HOST_DB=\${aws_db_instance.database-instance.address}" >> .env
  echo "BUCKET_NAME=${aws_s3_bucket.private_bucket.bucket}" >> .env
  echo "USER_DB=csye6225" >> .env
  echo "PASSWORD_DB=MariaGloria1" >> .env
  echo "DB_NAME=csye6225" >> .env
 

 EOF
 )

disable_api_termination = false // Set this to false to disable protection against accidental termination

  block_device_mappings {
  device_name = "/dev/sda1"
  ebs {
    volume_size = 50
    volume_type = "gp2"
    delete_on_termination = true
     
  }
}
    tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Terraform EC2"
      Source="Autoscaling"
    }
  }

lifecycle {
  create_before_destroy = true
}
 
}

