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



resource "aws_iam_policy" "cloudwatch_metrics" {
  name        = "cloudwatch-metrics-policy"
  description = "Policy to allow registering metrics in CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_metrics" {
  policy_arn = aws_iam_policy.cloudwatch_metrics.arn
  role       = aws_iam_role.EC2-CSYE6225.name
}
resource "aws_security_group" "metrics_security_group" {
  name_prefix = "metrics_security_group"
  vpc_id = aws_vpc.maria.id

  ingress {
    from_port   = 8125
    to_port     = 8125
    protocol    = "udp"
    security_groups = [aws_security_group.app_sg.id]

  }
}


