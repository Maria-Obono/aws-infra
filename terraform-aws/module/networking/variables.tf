variable "cidr_B" {
  type = string
  default = "10.0.0.0/16"
}

variable "cidr" {
  type = string
  
}


 
variable "key" {
  type = string
  default = "aws_key_pair.TF_key.id"
}

variable "regions" {
    type = list(string)
  default = [  "us-east-1","us-west-2","us-west-1" ]
}

variable "network_interface_id" {
  type = string
  default = "network_id_from_aws"
}

//variable "ami" {
    //type = map(string)
   // default = {
    //  "us-east-1" = "ami-0035fe499cb1864d1"
    //  "us-east-2"= "ami-0fd46f93cbc1377ce"
    //  "us-west-2" = "ami-08074cb8edfe78fb9"
  //  }
//}


//variable "instance_count" {
 // type = string
  //default = "3"
//}

variable "ami" {
  type = string
  default = "ami-0de31357999dcf26c"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}

//variable "providers" {
 // type = list(string)
  //default = [ "aws = aws.pup", "aws = aws.lolo", "aws = aws.popi" ]
  
//}

variable "instance_tags" {
  type = list(string)
  default = [ "mar1", "mar2", "mar3" ]
}

variable "providers_list" {
  type = map(string)
  default = {
    "aws" = "aws.pup" 
    "aws" = "aws.lolo"
    "aws" = "aws.popi" 
  }
}

variable "instance_count" {
  description = "The number of instances to create."
  type        = number
  default     = 1
}