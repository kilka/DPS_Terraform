# VPC
resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-vpc"
      ManagedBy = "Terraform"
      Purpose   = "Lab"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-igw"
      ManagedBy = "Terraform"
    }
  )
}

# Public Subnet (for jump host)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.lab.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone != null ? var.availability_zone : data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-public-subnet"
      ManagedBy = "Terraform"
      Type      = "Public"
    }
  )
}

# Private Subnet (for DDVE/AVE)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone != null ? var.availability_zone : data.aws_availability_zones.available.names[0]

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-private-subnet"
      ManagedBy = "Terraform"
      Type      = "Private"
    }
  )
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-nat-eip"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.lab]
}

# NAT Gateway
resource "aws_nat_gateway" "lab" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-nat-gateway"
      ManagedBy = "Terraform"
    }
  )

  depends_on = [aws_internet_gateway.lab]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-public-rt"
      ManagedBy = "Terraform"
    }
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.lab.id

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-private-rt"
      ManagedBy = "Terraform"
    }
  )
}

# NAT Gateway route in private route table (if NAT enabled)
resource "aws_route" "private_nat" {
  count                  = var.enable_nat_gateway ? 1 : 0
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lab[0].id
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table Association
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# S3 VPC Gateway Endpoint (for DDVE/AVE S3 access)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.lab.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private.id]

  tags = merge(
    var.tags,
    {
      Name      = "${var.lab_name}-s3-endpoint"
      ManagedBy = "Terraform"
    }
  )
}
