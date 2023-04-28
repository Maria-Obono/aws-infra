//Define autoscaling group
resource "aws_autoscaling_group" "web_app_asg" {
  name         = "asg_launch_config"
  vpc_zone_identifier = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id, aws_subnet.public-subnet[2].id]
  //vpc_id      = aws_vpc.maria.id
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = aws_launch_template.app_launch_template.latest_version
    }

  target_group_arns = [aws_lb_target_group.target_group.arn]
  
  
  min_size          = 1
  max_size          = 3
  desired_capacity  = 1
  health_check_grace_period = 600
  health_check_type     = "EC2"
  termination_policies      = ["Default"]
//instance_refresh {
    //strategy = "Rolling"
 // }

  tag  {
      key                 = "Name"
      value               = "Terraform ASG"
      propagate_at_launch = true
    }
     tag {
    key                 = "Application"
    value               = "webApp"
    propagate_at_launch = true
  }
# instance scale-in protection configuration
  //protect_from_scale_in = true
  
lifecycle {
//ignore_changes = [
      //"tag",
      //"desired_capacity",
      //desired_capacity,
      //min_size,
      //max_size,
      //launch_template,
      //target_group_arns,
      //health_check_type,
      //health_check_grace_period,
      //vpc_zone_identifier,
      //termination_policies,
   // ]
    create_before_destroy = true
}

 

}

//resource "aws_autoscaling_lifecycle_hook" "example" {
//  name                 = "example-lifecycle-hook"
//  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
//  default_result       = "CONTINUE"
//  heartbeat_timeout    = 300
 // lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"

  
//}


 
resource "aws_iam_policy" "asg_policy" {
  name = "asg-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:UpdateAutoScalingGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asg_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.EC2-CSYE6225.name
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name
  alb_target_group_arn   = aws_lb_target_group.target_group.arn
}

resource "aws_lb_listener_rule" "web_app_listener_rule" {
  listener_arn = aws_lb_listener.alb_https_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn

  }

  condition {
    path_pattern {
      values = ["/health"]
    }
  }
  condition {
    host_header {
      values = ["${aws_lb.load_balancer.dns_name}"]
      
    }
  }

  condition {
    http_request_method {
      values = ["GET"]
    }
  }

 
}

