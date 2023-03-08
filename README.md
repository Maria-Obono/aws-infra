# aws-infra

Here is what you need to do for networking infrastructure setup:

Create Virtual Private Cloud (VPC)Links to an external site..
Create subnetsLinks to an external site. in your VPC. You must create 3 public subnets and 3 private subnets, each in a different availability zone in the same region in the same VPC.
Create an Internet GatewayLinks to an external site. resource and attach the Internet Gateway to the VPC.
Create a public route tableLinks to an external site.. Attach all public subnets created to the route table.
Create a private route tableLinks to an external site.. Attach all private subnets created to the route table.
Create a public route in the public route table created above with the destination CIDR block 0.0.0.0/0 and the internet gateway created above as the target.

 Commands to execute:

 Terraform:
 -create a terraform template

 1. Terraform init
 2. terraform plan
 3. terraform apply
 4. terraform destroy

FOR PACKER:
-create a packer template

1. packer validate 
2. packer init 
3. packer fmt
4. packer build