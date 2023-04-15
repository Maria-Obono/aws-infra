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
  default = [ "10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20" ]
}

variable "private_subnet_cidr_blocks" {
  description = "available CIDR blocks for private subnets"
  type = list(string)
  default = [ "10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20" ]
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

variable "domain_name" {
  default = "mariaobono.me"
  description = "domain name"
  type = string
}

