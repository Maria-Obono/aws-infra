
//resource "aws_autoscaling_policy" "scaling_policy" {
  //name                   = "scaling_policy"
 // policy_type            = "TargetTrackingScaling"
  //adjustment_type        = "ChangeInCapacity"
  //estimated_instance_warmup = 60
  //autoscaling_group_name = aws_autoscaling_group.web_app_asg.name

  //target_tracking_configuration {
   // predefined_metric_specification {
   //   predefined_metric_type = "ASGAverageCPUUtilization"
   // }
   // target_value = 4.5
  //}

//}

//resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  //alarm_name          = "cpu_utilization_alarm"
  //comparison_operator = "GreaterThanThreshold"
  //evaluation_periods  = "1"
  //metric_name         = "CPUUtilization"
  //namespace           = "AWS/EC2"
 // period              = "60"
  //statistic           = "Sum"
  //threshold           = "5"
  //alarm_description   = "Alarm for high CPU utilization"
//}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale_up_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"
  alarm_description   = "Alarm for scaling up based on high CPU utilization"

  alarm_actions = [
    aws_autoscaling_policy.scale_up_policy.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale_down_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "3"
  alarm_description   = "Alarm for scaling down based on low CPU utilization"

  alarm_actions = [
    aws_autoscaling_policy.scale_down_policy.arn
  ]
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale_up_policy"
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name

  policy_type            = "SimpleScaling"
  
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale_down_policy"
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = "300"
  autoscaling_group_name = aws_autoscaling_group.web_app_asg.name

  policy_type            = "SimpleScaling"
}


