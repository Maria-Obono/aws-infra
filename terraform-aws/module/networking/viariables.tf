variable "rds_instance_identifier" {
    type = string
    default = "csye6225"
}
variable "database_name" {
    type = string
    default = "csye6225"
}
variable "database_password" {
   // type = string
    default = {
        database_password = "some-random-password"
    }
}
variable "database_user" {
    type = string
    default = "csye6225"
}
variable "environment" {
    type = string
    default = "dev"
}

///////////////////////////////////////////////////

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidir_block" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
  
}

variable "subnet_count" {
  description = "Number of subnets"
  type = map(number)
  default = {
    public = 3,
    private= 3
  }
}

variable "settings" {
  description = "configure settings"
  type = map(any)
  default = {
    "database" = {
      engine= "mysql"
      instance_class= "db.t3.micro"
      multi_az= false
      instance_class= "csye6225"
      db_name= "csye6225"
      identifier= "csye6225"
      publicity_accessibility= false
      
    },
    "web_app" = {
      count = 1
      instance_type= "t2.micro"
    }
  }
  
}

variable "public_subnet_cidr_blocks" {
  description = "available CIDR blocks for public subnets"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "private_subnet_cidr_blocks" {
  description = "available CIDR blocks for private subnets"
  type = list(string)
  default = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24" ]
}

variable "my_ip" {
  description = "my IP address"
  type = string
  sensitive = true
  
}

variable "db_username" {
  description = "Database master user"
  type = string
  sensitive = true
  
}

variable "db_password" {
  description = "Database master user password"
  type = string
  sensitive = true
  
}

//variable "bucket_name" {}
variable "acl_value" {
    type = string
    default = "private"
}