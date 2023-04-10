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

  health_check_grace_period = 300

  health_check_type     = "EC2"

  //defining the termination policy where the instance with the least connections will be terminated first
  //termination_policies = ["OldestLaunchConfiguration", "OldestInstance", "ClosestToNextInstanceHour", "NewestInstance", "OldestLaunchTemplate", "Default"]

  # force_delete deletes the Auto Scaling Group without waiting for all instances in the pool to terminate
  //force_delete              = true
  # Defining the termination policy where the oldest instance will be replaced first 
  //termination_policies      = ["OldestInstance"]


  tag  {
      key                 = "Name"
      value               = "Terraform ASG"
      propagate_at_launch = true
    }
  
lifecycle {
create_before_destroy = true
}
}

output "load_balancer_dns_name" {
value = aws_lb.load_balancer.dns_name
}
output "target_group_arn" {
value = aws_lb_target_group.target_group.arn
}
output "app_security_group_id" {
value = aws_security_group.app_sg.id
}
output "launch_template_id" {
value = aws_launch_template.app_launch_template.id
}
output "autoscaling_group_id" {
value = aws_autoscaling_group.web_app_asg.id
}


 
