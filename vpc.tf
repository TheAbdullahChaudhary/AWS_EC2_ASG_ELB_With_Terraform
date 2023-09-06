# -----------------------------------------Define the VPC  -----------------------------------------
resource "aws_vpc" "asg_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ----------------------------------------- Define the subnet in ap-southeast-2  "a" -----------------------------------------

resource "aws_subnet" "asg_subnet_1" {
  vpc_id                  = aws_vpc.asg_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-southeast-2a" # Choose the desired availability zone in ap-southeast-2
  map_public_ip_on_launch = true
}



# ----------------------------------------- Define the subnet in ap-southeast-2  "b" -----------------------------------------

resource "aws_subnet" "asg_subnet_2" {
  vpc_id                  = aws_vpc.asg_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-2b" # Choose the desired availability zone in ap-southeast-2
  map_public_ip_on_launch = true
}

# -----------------------------------------Create an Internet Gateway -----------------------------------------
resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.asg_vpc.id
}

# -----------------------------------------Create a Route Table -----------------------------------------
resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.asg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }
}


# Associate Route Table with Subnet 1
resource "aws_route_table_association" "rt_subnet_1" {
  subnet_id      = aws_subnet.asg_subnet_1.id
  route_table_id = aws_route_table.my_rt.id
}

# Associate Route Table with Subnet 2
resource "aws_route_table_association" "rt_subnet_2" {
  subnet_id      = aws_subnet.asg_subnet_2.id
  route_table_id = aws_route_table.my_rt.id
}