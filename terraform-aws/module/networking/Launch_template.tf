resource "aws_launch_template" "app_launch_template" {
  
  image_id = data.aws_ami.app_ami.id
  instance_type = var.settings.web_app.instance_type
  key_name = "Key"
  placement {
    availability_zone = data.aws_availability_zones.available.id
  }

    network_interfaces {
    device_index = 0
    associate_public_ip_address = true
    subnet_id       = aws_subnet.public-subnet[0].id
    security_groups = [aws_security_group.app_sg.id]
    
  }
  iam_instance_profile {
   arn= aws_iam_instance_profile.maria_profile.arn
  }

  user_data = base64encode(data.template_file.user_data.rendered)

  disable_api_termination = false // Set this to false to disable protection against accidental termination
  monitoring {
    enabled = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags = "enabled"
  }
 

  block_device_mappings {
  device_name = "/dev/sda1"
  ebs {
    volume_size = 50
    volume_type = "gp2"
    encrypted = true
    delete_on_termination = true
  }
}
    tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "asg_launch_config"
      vpc_id      = aws_vpc.maria.id
      role        = aws_iam_role.EC2-CSYE6225.name
    }
  }

lifecycle {
  create_before_destroy = true
}
 
}

