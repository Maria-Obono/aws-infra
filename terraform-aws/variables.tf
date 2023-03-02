
variable "regions" {
    type = list(string)
  default = [  "us-east-1","us-west-2","us-west-1" ]
}

variable "key" {
  type    = string
  default = "aws_key_pair.TF_key.id"
}

variable "vpc_id" {
    type = string
  default = "aws_vpc.maria.id"
}

variable "cidr_B" {
  type = string
  default = "10.0.0.0/16"
}

variable "ami" {
    type = string
    default = "ami-0de31357999dcf26c"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "instance_count" {
  description = "The number of instances to create."
  type        = number
  default     = 1
}

variable "providers_list" {
  type = map(string)
  default = {
    "aws" = "aws.pup" 
    "aws" = "aws.lolo"
    "aws" = "aws.popi" 
  }
}

variable "instance_tags" {
  type = list(string)
  default = [ "mar1", "mar2", "mar3" ]

  
}

variable "aws_region" {
  default = "us-east-1"
}