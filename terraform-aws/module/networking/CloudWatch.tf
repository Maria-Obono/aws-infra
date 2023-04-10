//policy that allows the agent to write logs to CloudWatch

resource "aws_iam_policy" "cloudwatch_agent" {
  name        = "cloudwatch-agent-policy"
  policy      = jsonencode({

   Version= "2012-10-17",
    Statement= [
        {
            Effect= "Allow",
            Action= [
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            Resource= "*"
        },
        {
            Effect= "Allow",
            Action= [
                "ssm:GetParameter"
            ],
            Resource= "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        }
    ]

  })
}



resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  policy_arn = aws_iam_policy.cloudwatch_agent.arn
  role       = aws_iam_role.EC2-CSYE6225.name
}

# Custom metrics for API usage
resource "aws_cloudwatch_metric_alarm" "api_calls_metric" {
  alarm_name          = "api-calls-metric"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "API_Calls"
  namespace           = "MyApp"
  period              = "60"
  statistic           = "Sum"
  threshold           = "1"
  alarm_description   = "Alarm for API Calls"
  alarm_actions       = ["arn:aws:sns:us-east-1:123456789012:my-sns-topic", "${aws_autoscaling_policy.scaling_policy.arn}" ]
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_app_asg.name}"
  }
}



