output "web_public_ip" {
  description = "The public IP address of the web server"

  //we are grabbing it from the Elastic IP
  value = aws_eip.myApp_eip[0].public_ip

  //this output waits for the Elastic IPS to be created and distributed

  depends_on = [
    aws_eip.myApp_eip
  ]
}

output "web_public_dns" {
  description = "The public DNS address on the web server"

  value = aws_eip.myApp_eip[0].public_dns

  depends_on = [
    aws_eip.myApp_eip
  ]
}

//this will output the database endpoint
output "database_endpoint" {
    description = "the endpoint of the database"
    value = aws_db_instance.database-instance.address
  
}

//this will ouput the database port

output "database_port" {
  description = "the port of the database"
  value = aws_db_instance.database-instance.port
}