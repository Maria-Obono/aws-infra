resource "random_id" "my-random-id" {
byte_length = 8
}
resource "aws_s3_bucket" "private_bucket" {
  bucket = "my-bucket-${random_id.my-random-id.hex}"
  force_destroy = true
  
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

  tags = {
    Environment = var.environment
    Owner       = var.db_username
    Name        = "my-bucket-${random_id.my-random-id.hex}"
  }

   versioning {
    enabled = true
  }
}

data "aws_s3_bucket" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id
}


data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "private" {
  bucket = aws_s3_bucket.private_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "DenyInsecureTransport"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:*"
        Resource = "${aws_s3_bucket.private_bucket.arn}/*"
        Condition = {
          Bool = {
            "aws:SecureTransport": true
          }
        }
      }
    ]
  })
}



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
          "arn:aws:s3:::my-bucket-${random_id.my-random-id.hex}/*"
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


 
}
resource "aws_iam_role_policy_attachment" "some_bucket_policy" {
  role       = aws_iam_role.EC2-CSYE6225.name
  policy_arn = aws_iam_policy.WebAppS3.arn
}

resource "aws_iam_instance_profile" "maria_profile" {
  name = "maria-profile"
  role = aws_iam_role.EC2-CSYE6225.name
  
}

