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

Here is how to import a certificate using the AWS Command Line Interface (AWS CLI). Assuming:

The PEM-encoded certificate is stored in a file named Certificate.pem.
The PEM-encoded certificate chain is stored in a file named CertificateChain.pem.
The PEM-encoded, unencrypted private key is stored in a file named PrivateKey.pem.
To use the following example, replace the file names with your own and type the command on one continuous line. The following example includes line breaks and extra spaces to make it easier to read.

$ aws acm import-certificate --certificate fileb://Certificate.pem \
      --certificate-chain fileb://CertificateChain.pem \
      --private-key fileb://PrivateKey.pem
If the import-certificate command is successful, it returns the Amazon Resource Name (ARN) of the imported certificate..