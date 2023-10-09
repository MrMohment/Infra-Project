provider "aws" {
  region = "us-east-1"
}

# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Infra-project VPC"
  }
}

# Create Subnets
resource "aws_subnet" "pub1" {
  cidr_block        = "10.0.0.0/23"
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "Public 1"
  }
}

resource "aws_subnet" "pub2" {
  cidr_block        = "10.0.16.0/23"
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.vpc.id

  tags = {
    Name = "Public 2"
  }
}

resource "aws_subnet" "private1" {
  cidr_block              = "10.0.128.0/23"
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "Private 1"
  }
}

resource "aws_subnet" "private2" {
  cidr_block              = "10.0.144.0/23"
  availability_zone       = "us-east-1b"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "Private 2"
  }
}

resource "aws_subnet" "db1" {
  cidr_block              = "10.0.160.0/23"
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "DB 1"
  }
}

resource "aws_subnet" "db2" {
  cidr_block              = "10.0.176.0/23"
  availability_zone       = "us-east-1b"
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false

  tags = {
    Name = "DB 2"
  }
}

# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW_InfraProject"
  }
}

# Create NAT Gateway
resource "aws_eip" "nat1_eip" {
  domain = "standard"

  tags = {
    Name = "eip1_InfraProject"
  }
}

resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.nat1_eip.id
  subnet_id     = aws_subnet.pub1.id

  tags = {
    Name = "NAT1_InfraProject"
  }
}

resource "aws_eip" "nat2_eip" {
  domain = "standard"

  tags = {
    Name = "eip2_InfraProject"
  }
}

resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.nat2_eip.id
  subnet_id     = aws_subnet.pub2.id

  tags = {
    Name = "NAT2_InfraProject"
  }
}

# Create Route tables
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Public.RT_InfraProject"
  }
}

resource "aws_route" "pub_rt" {
  route_table_id         = aws_route_table.pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private1_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private1.RT_InfraProject"
  }
}

resource "aws_route" "private1_rt" {
  route_table_id         = aws_route_table.private1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat1.id
}

resource "aws_route_table" "private2_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private2.RT_InfraProject"
  }
}

resource "aws_route" "private2_rt" {
  route_table_id         = aws_route_table.private2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat2.id
}

resource "aws_route_table" "db_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "DB.RT_InfraProject"
  }
}

# Associate the route tables with subnets
resource "aws_route_table_association" "public1" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub1.id
}

resource "aws_route_table_association" "public2" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.pub2.id
}

resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.private1_rt.id
  subnet_id      = aws_subnet.private1.id
}

resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.private2_rt.id
  subnet_id      = aws_subnet.private2.id
}

resource "aws_route_table_association" "db1" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.db1.id
}

resource "aws_route_table_association" "db2" {
  route_table_id = aws_route_table.db_rt.id
  subnet_id      = aws_subnet.db2.id
}