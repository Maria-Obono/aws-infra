resource "aws_vpc" "maria" {
  //count = var.instance_count
  cidr_block           = var.cidr_B
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = "maria"
  }
  
}

resource "aws_internet_gateway" "my-internet-gateway" {
  vpc_id = aws_vpc.maria.id
  tags = {
    Name = "myIGW"
  }
}

data "aws_availability_zones" "available" {
 state = "available"
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                          = aws_vpc.maria.id
  cidr_block                      = "10.0.0.0/20"
  availability_zone               = "${data.aws_availability_zones.available.names[0]}"
  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                          = aws_vpc.maria.id
  cidr_block                      = "10.0.16.0/20"
  availability_zone               = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "public-subnet3" {
  vpc_id                          = aws_vpc.maria.id
  cidr_block                      = "10.0.32.0/20"
  availability_zone               = "${data.aws_availability_zones.available.names[2]}"
  tags = {
    Name = "public_subnet3"
  }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id                          = aws_vpc.maria.id
  cidr_block                      = "10.0.128.0/20"
  availability_zone               = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id                          = aws_vpc.maria.id
  cidr_block                      = "10.0.144.0/20"
  availability_zone               = "${data.aws_availability_zones.available.names[1]}"
  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_subnet" "private-subnet3" {
  vpc_id                          = aws_vpc.maria.id
  cidr_block                      = "10.0.160.0/20"
  availability_zone               = "${data.aws_availability_zones.available.names[2]}"
  tags = {
    Name = "private_subnet3"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.maria.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-internet-gateway.id
  }
  tags = {
    Name = "public route"
  }
}

resource "aws_route_table_association" "public-subnet-route-table-association1" {
  
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-route-table-association2" {
  
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-route-table-association3" {
  
  subnet_id      = aws_subnet.public-subnet3.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.maria.id

  tags = {
    Name = "private route"
  }
}

resource "aws_route_table_association" "private-subnet-route-table-association1" {
 
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-route-table.id
  
}

resource "aws_route_table_association" "private-subnet-route-table-association2" {
 
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-route-table-association3" {
 
  subnet_id      = aws_subnet.private-subnet3.id
  route_table_id = aws_route_table.private-route-table.id
}



//////////////////////////////////////////////////



