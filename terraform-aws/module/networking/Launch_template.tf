

resource "aws_launch_template" "app_launch_template" {
  name_prefix             = "web_application"
  image_id                = data.aws_ami.app_ami.id
  instance_type           = var.settings.web_app.instance_type
  key_name                = "Key"
 
  disable_api_termination = false

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 50
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = aws_kms_key.customer_managed_key.arn
    }
  }

  user_data = base64encode(data.template_file.user_data.rendered)
monitoring {
    enabled = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "optional"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name"  = "Terraform EC2"
      "vpc_id" = aws_vpc.maria.id
      "role"   = aws_iam_role.EC2-CSYE6225.name
    }
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
    subnet_id                   = "${aws_subnet.public-subnet[0].id}"
  }

  hibernation_options {
    configured = false
  }
  lifecycle {
  create_before_destroy = true
}


}

resource "aws_kms_key" "customer_managed_key" {
  description             = "Customer managed KMS key"
  deletion_window_in_days = 7
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = "kms:*"
        Resource = "*"
      },
      {
        Sid = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::272647741966:root"
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

