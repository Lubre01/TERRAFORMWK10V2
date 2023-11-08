# Create a VPC
resource "aws_vpc" "vpc1" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "week10-vpc"
    env  = "Dev"
  }
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# Create an Internet Gateway
resource "aws_internet_gateway" "gtw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "IGW"
  }
}

# Create a public subnet in availability zone a
resource "aws_subnet" "public_subnet1" {
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-vpc-a"
    env  = "Dev"
  }
}

# Create a public subnet in availability zone b
resource "aws_subnet" "public_subnet2" {
  availability_zone       = "us-east-1b"
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "172.16.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-public-vpc-b"
    env  = "Dev"
  }
}

# Create private subnets in availability zones a and b
resource "aws_subnet" "private_subnet1" {
  availability_zone = "us-east-1a"
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "172.16.3.0/24"
  tags = {
    Name = "subnet-private-vpc-a"
    env  = "Dev"
  }
}

resource "aws_subnet" "private_subnet2" {
  availability_zone = "us-east-1b"
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "172.16.4.0/24"
  tags = {
    Name = "subnet-private-vpc-b"
    env  = "Dev"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc1.id
}

# Create a route table for the private subnets
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc1.id
}

# Create a default route for the public route table
resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gtw1.id
}

# Associate the public subnets with the public route table
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt_public.id
}