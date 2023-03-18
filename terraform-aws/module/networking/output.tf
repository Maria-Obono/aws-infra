
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