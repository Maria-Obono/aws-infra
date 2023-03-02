module "networking" {

  source = "./module/networking"
  cidr =     "10.0.0.0/16"
 
 
providers= {
    aws.src = aws.pup
    
    aws.dst= aws.lolo

   }

}