resource "aws_vpc" "maria" {
  
  cidr_block           = var.vpc_cidir_block
  
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

resource "aws_subnet" "public-subnet" {

  count = var.subnet_count.public
  vpc_id = aws_vpc.maria.id
 map_public_ip_on_launch = true
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "public_subnet_${count.index}"
  }
}


resource "aws_subnet" "private-subnet" {

  count = var.subnet_count.private
  vpc_id = aws_vpc.maria.id
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private_subnet_${count.index}"
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

resource "aws_route_table_association" "public-subnet-route-table-association" {
  count = var.subnet_count.public
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.maria.id

  tags = {
    Name = "private route"
  }
}

resource "aws_route_table_association" "private-subnet-route-table-association" {
  count = var.subnet_count.private
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-route-table.id
  
}

//////////////////////////////////////////////////



