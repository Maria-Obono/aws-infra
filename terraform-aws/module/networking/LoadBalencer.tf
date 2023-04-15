#create aws_lb_target_group
resource "aws_lb_target_group" "target_group" {
  name        = "my-target-group"
  port        = 5050
  protocol    = "HTTP"
  vpc_id      = aws_vpc.maria.id
  target_type = "instance"

    health_check {
      //enabled             = true
      port= 5050
      protocol            = "HTTP"
      path                = "/health"
      matcher             = "200"
      //timeout             = 60
     // unhealthy_threshold = 2
      healthy_threshold   = 2
      interval            = 30


  }
  
  tags = {
    Name = "Terraform Target Group"
  }
}

resource "aws_lb_target_group_attachment" "alb-tg-attach" {
  count = var.settings.web_app.count
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.web_application[count.index].id
  port             = 5050
  
}
#create aws_lb
resource "aws_lb" "load_balancer" {
  name               = "web-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  security_groups    = [aws_security_group.load_balancer_sg.id]
 
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  //enable_cross_zone_load_balancing = true
  tags = {
    Name = "WebApp"
  }
}

#create aws_lb_listener
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Create a listener to accept HTTP traffic and forward it to instances on port 5050
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:272647741966:certificate/6af0d517-e8ee-4104-bad4-31afddb5718a"

  default_action {
    target_group_arn = aws_lb_target_group.target_group.arn
    type             = "forward"
  }
  
}


resource "aws_acm_certificate" "ssl_cert" {
private_key      = "${file("../../../Certify/PrivateKey.pem")}"
certificate_body = "${file("../../../Certify/Certificate.pem")}"
certificate_chain = "${file("../../../Certify/CertificateChain.pem")}"
}

# Define the load balancer security group
resource "aws_security_group" "load_balancer_sg" {
  name        = "load_balancer_sg"
  vpc_id      = aws_vpc.maria.id
  description = "allow TCP traffic on ports 80 and 443 from anywhere"
  tags = {
    Name = "LoadBalancer_SG"
  }
}
resource "aws_security_group_rule" "http_allow" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.load_balancer_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "https_allow" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.load_balancer_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id = aws_security_group.load_balancer_sg.id
  cidr_blocks              = ["0.0.0.0/0"]
}

