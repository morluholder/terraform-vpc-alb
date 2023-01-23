# VPC RESOURCE

resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = merge(
      {
          Name = "mobikart3-vpc"
      }
  )
}

# WEBSERVER SUBNET1 RESOURCE

resource "aws_subnet" "webserver-sn1" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = merge(
      {
          Name = "public-mobikart3-sn1"
      }
  )
}

# WEBSERVER SUBNET2 RESOURCE

resource "aws_subnet" "webserver-sn2" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = merge(
      {
          Name = "public-mobikart3-sn2"
      }
  )
}

# APPLICATION SUBNET  RESOURCE

resource "aws_subnet" "application-sn" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = merge(
      {
          Name = "private-mobikart3-sn1"
      }
  
  )
}

# DATABASE SUBNET  RESOURCE

resource "aws_subnet" "database-sn" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = merge(
      {
          Name = "private-mobikart3-sn2"
      }
  
  )
}

#  INTERNET GATEWAY RESOURCE
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

   tags = merge(
      {
          Name = "mobikart3-igw"
      }
  )
}

# RESOURCE ELASTIC IP FOR NAT GATEWAY

# resource "aws_eip" "main-nat-eip" {
#   vpc = true

#   tags = merge(
#       {
#           Name = "mobikart3-eip"
#       } 
#   )
# }

# RESOURCE NAT GATEWAY

# resource "aws_nat_gateway" "main-nat" {
#   allocation_id = aws_eip.main-nat-eip.id
#   subnet_id     = aws_subnet.webserver-sn1.id

#   tags = merge(
#       {
#           Name = "mobikart3-nat-gateway"
#       }
#   )
# }

# PUBLIC ROUTE TABLE RESOURCE
# PUBLIC ROUTE TABLE ROUTE

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = merge(
      {
          Name = "public-mobikart3-rt"
      }
  )
}

# PUBLIC ROUTE TABLE ASSOCIATION RESOURCE
resource "aws_route_table_association" "public-sn-association" {
  subnet_id      = aws_subnet.webserver-sn1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-sn-association2" {
  subnet_id      = aws_subnet.webserver-sn2.id
  route_table_id = aws_route_table.public-rt.id
}

# PRIVATE ROUTE TABLE RESOURCE
# PRIVATE ROUTE TABLE ROUTE RESOURCE

# resource "aws_route_table" "private-rt" {
#   vpc_id = aws_vpc.main-vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.main-nat.id
#   }

#   tags = {
#     "Name" = "private-mobikart3-rt"
#   }
# }

# PRIVATE ROUTE TABLE ASSOCIATION RESOURCE
# resource "aws_route_table_association" "private-mobikart-sn1-association" {
#   subnet_id      = aws_subnet.application-sn.id
#   route_table_id = aws_route_table.private-rt.id
# }

# resource "aws_route_table_association" "private-mobikart-sn2-association" {
#   subnet_id      = aws_subnet.database-sn.id
#   route_table_id = aws_route_table.private-rt.id
# }

# END OF RESOURCES CREATIONS