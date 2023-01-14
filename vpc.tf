
# Create a VPC
resource "aws_vpc" "shoval_vpc_iac" {
  cidr_block = "42.0.0.0/16"
  tags = {
    Name = "shoval_vpc_iac"
  }
}
# Create a Subnet
resource "aws_subnet" "sub_1_shoval_iac" {
  vpc_id     = aws_vpc.shoval_vpc_iac.id
  cidr_block = "42.0.10.0/24"
  availability_zone = "eu-west-3a"
  map_public_ip_on_launch = true 
  tags = {
    Name = "sub_1_shoval_iac"
  }
}
resource "aws_subnet" "sub_2_shoval_iac" {
  vpc_id     = aws_vpc.shoval_vpc_iac.id
  cidr_block = "42.0.20.0/24"
  availability_zone = "eu-west-3b"
  map_public_ip_on_launch = true 
  tags = {
    Name = "sub_2_shoval_iac"
  }
}
# Create a IG
resource "aws_internet_gateway" "internet_gateway_shoval_iac" {
  vpc_id = aws_vpc.shoval_vpc_iac.id

  tags = {
    Name = "internet_gateway_shoval_iac"
  }
}
# Create a route
resource "aws_route_table" "shoval_route_iac" {
  vpc_id = aws_vpc.shoval_vpc_iac.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_shoval_iac.id
  }
  tags = {
    "Name" = "shoval_route_iac"
  }
}
# association subnet
resource "aws_route_table_association" "sub_1_shoval_iac_ass" {
  subnet_id      = aws_subnet.sub_1_shoval_iac.id
  route_table_id = aws_route_table.shoval_route_iac.id
}
resource "aws_route_table_association" "sub_2_shoval_iac_ass" {
  subnet_id      = aws_subnet.sub_2_shoval_iac.id
  route_table_id = aws_route_table.shoval_route_iac.id
}