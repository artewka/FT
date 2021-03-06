#create vpc
resource "aws_vpc" "Vpc_Ter" {
  cidr_block  = var.cidr_block
  instance_tenancy = "default"

  tags = {
    "Name" = "${var.environment} vpc"
  }
}

#get availables zones from default region
data "aws_availability_zones" "available" {}

#create internet gateway
resource "aws_internet_gateway" "gwT" {
  vpc_id = aws_vpc.Vpc_Ter.id

  tags = {
    Name = "${var.environment} gateway"
  }
}

#get static external ip for NAT Gateway
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "${var.environment}-eip"
  }
}

#create NAT Gateway
resource "aws_nat_gateway" "ngwT" {
 
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.Private[0].id

  tags = {
    Name = "${var.environment}-nat_gw"
  }

  depends_on = [aws_internet_gateway.gwT, aws_eip.eip]
}


#Route tables
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.Vpc_Ter.id

  route {
    cidr_block = var.route_public_cidr_block
    gateway_id = aws_internet_gateway.gwT.id
  }

  tags = {
    Name = "${var.environment}-public_route table"
  }
}

resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.Vpc_Ter.id

  route {
    cidr_block = var.route_public_cidr_block
    gateway_id = aws_internet_gateway.gwT.id
  }

  tags = {
    Name = "${var.environment}-private_route table"
  }
}

resource "aws_route_table" "route_private_db" {
  vpc_id = aws_vpc.Vpc_Ter.id
  
  route {
    cidr_block = var.route_public_cidr_block
    gateway_id = aws_internet_gateway.gwT.id
  }
  
  tags = {
    Name = "${var.environment}-db_route table"
  }
}


#Create subnets
resource "aws_subnet" "Public" {
  count                   = length(var.public_cidr_block)
  vpc_id                  = aws_vpc.Vpc_Ter.id
  cidr_block              = element(var.public_cidr_block,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.environment}-public subnet"
  }
}

resource "aws_subnet" "Private" {
  count                   = length(var.private_cidr_block)
  vpc_id                  = aws_vpc.Vpc_Ter.id
  cidr_block              = element(var.private_cidr_block,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "${var.environment}-private subnet"
  }
}

resource "aws_subnet" "DB" {
  vpc_id                  = aws_vpc.Vpc_Ter.id
  cidr_block              = "10.0.211.0/24"
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = "true"
  
  tags = {
    Name = "${var.environment}-db subnet"
  }
}


#Associate route tables with subnets
resource "aws_route_table_association" "public" {
  count          = length (aws_subnet.Public[*])
  subnet_id      = element(aws_subnet.Public[*].id,count.index)
  route_table_id = aws_route_table.route_public.id
}

resource "aws_route_table_association" "private" {
  count          = length (aws_subnet.Private[*])
  subnet_id      = element(aws_subnet.Private[*].id,count.index)
  route_table_id = aws_route_table.route_private.id
}

resource "aws_route_table_association" "db" {
  subnet_id      = aws_subnet.DB.id
  route_table_id = aws_route_table.route_private_db.id
}
