//Define autoscaling group
resource "aws_autoscaling_group" "web_app_asg" {
  name         = "asg_launch_config"
  vpc_zone_identifier = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  
  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
    }

  target_group_arns = [aws_lb_target_group.target_group.arn]
  
  
  min_size          = 1
  max_size          = 3
  desired_capacity  = 1
  health_check_grace_period = 90
  health_check_type     = "ELB"
  termination_policies      = ["Default"]
instance_refresh {
    strategy = "Rolling"
  }

  tag  {
      key                 = "Name"
      value               = "Terraform ASG"
      propagate_at_launch = true
    }
     tag {
    key                 = "Environment"
    value               = "Development"
    propagate_at_launch = true
  }
  
lifecycle {
create_before_destroy = true
}
//metric {
    //name = "CPUUtilization"
    //namespace = "AWS/EC2"
    //statistic = "Average"
    //period = 60
    //unit = "Percent"
  //}

}


 
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
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.id
  alb_target_group_arn   = aws_lb_target_group.target_group.arn
}