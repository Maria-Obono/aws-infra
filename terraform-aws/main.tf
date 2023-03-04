module "networking" {

  source = "./module/networking"
  //cidr =     "10.0.0.0/16"
db_username= var.db_username
db_password = var.db_password
my_ip = var.my_ip
 
//providers= {
   // aws= aws.pup
    //aws.dst= aws.lolo

  // }
providers = {
  aws = "us-east-1"
 //}
}

   

}