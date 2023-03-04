resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-bucket-${var.environment}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "transition-to-standard-ia"
    enabled =    true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          //"${aws_s3_bucket.private_bucket.arn}/*"
        ]
        Condition = {
          StringNotEquals = {
            "aws:PrincipalArn": [
              "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.db_username}",
              #"arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.administrator}"
            ]
          }
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Owner       = var.db_username
    Name        = "my-bucket-${var.environment}"
  }
}

data "aws_caller_identity" "current" {}

//resource "random_id" "hex" {
  //byte_length = 4
//}






resource "aws_iam_policy" "WebAppS3" {
  name        = "WebAppS3"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject*",
          "s3:GetObject*",
          "s3:ListBucket*",
          "s3:DeleteObject*"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::my-bucket-${var.environment}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "EC2-CSYE6225" {
  name = "EC2-CSYE6225"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "some_bucket_policy" {
  role       = aws_iam_role.EC2-CSYE6225.name
  policy_arn = aws_iam_policy.WebAppS3.arn
}

resource "aws_iam_role_policy_attachment" "cloud_watch_policy" {
  role       = aws_iam_role.EC2-CSYE6225.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

}

resource "aws_iam_instance_profile" "maria_profile" {
  name = "maria-profile"
  role = aws_iam_role.EC2-CSYE6225.name
}

