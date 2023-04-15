resource "aws_autoscaling_policy" "scaling_policy" {
  name                   = "scaling_policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 60
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 4.0
  }

}






