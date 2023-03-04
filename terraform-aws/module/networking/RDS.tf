
#subnet group with all of our RDS subnets. The group will be applied to the database instance


resource "aws_db_subnet_group" "database-subnets" {
  name        = "${var.rds_instance_identifier}-subnet-group"
  description = "Terraform RDS subnet group"
  
  subnet_ids = [for subnet in aws_subnet.private-subnet : subnet.id]
}

#Create a RDS security group

resource "aws_security_group" "database" {
  name        = "terraform_rds_security_group"
  description = "Terraform RDS MySQL server"
  vpc_id      = "${aws_vpc.maria.id}"
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
  }
}

#Create a RDS MySQL database instance in the VPC with our RDS subnet group and security group

resource "aws_db_instance" "database-instance" {
  multi_az = false
  identifier                = var.settings.database.identifier
  #allocated_storage         = 5
  engine                    = var.settings.database.engine
  #engine_version            = "5.6.35"
  instance_class            = var.settings.database.instance_class
  db_name                   = var.settings.database.db_name
  username                  = var.db_username
  password                  = var.db_password
  db_subnet_group_name      = aws_db_subnet_group.database-subnets.id
  vpc_security_group_ids    = [aws_security_group.database.id]
  publicly_accessible     = false
  #skip_final_snapshot       = true
  #final_snapshot_identifier = "Ignore"
}


# Define the RDS parameter group
resource "aws_db_parameter_group" "parameters" {
  name        = "${var.rds_instance_identifier}-param-group"
  description = "Terraform parameter group for mysql5.6"
  family      = "mysql5.6"
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }
  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
