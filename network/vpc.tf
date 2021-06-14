##################################################################################
# RESOURCES VPC
##################################################################################

#-------------------------------------------------------------------------- // VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpcCidr
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = merge(local.common_tags, { Name = "${var.environment_tag}" })
}

#-------------------------------------------------------------------------- // Subnet
/* Public Subnet */
resource "aws_subnet" "vpcPublicSubnet" {
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(var.vpcCidr, 9, 8 + count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.common_tags, { Name = "${var.environment_tag}Public0${count.index + 1}" })
}

/* Private Subnet */
resource "aws_subnet" "vpcPrivateSubnet" {
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(var.vpcCidr, 9, 10 + count.index)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.common_tags, { Name = "${var.environment_tag}Private0${count.index + 1}" })
}


#-------------------------------------------------------------------------- // Igw Public Route Table with Subnet Association
/* Internet Gateway */
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.common_tags, { Name = "${var.environment_tag}-Igw" })
}

/* Route Table with Internet Gateway */
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-publicRT" })
}

/* Subnet Association */
resource "aws_route_table_association" "publicRTAss" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.vpcPublicSubnet[count.index].id
  route_table_id = aws_route_table.publicRT.id
}

#-------------------------------------------------------------------------- // Nat Gateway Nat Route Table with Subnet Association
/* Elastic IP for NAT */
resource "aws_eip" "natEip" {
  vpc        = true
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-natEip" })
}

/* Nat Gateway */
resource "aws_nat_gateway" "vpcNat" {
  allocation_id = aws_eip.natEip.id
  subnet_id     = aws_subnet.vpcPublicSubnet[0].id
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-natGateway" })

}

/* Nat Route Table */
resource "aws_route_table" "natRT" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.vpcNat.id
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-natRT" })
}

/* Subnet Association */
resource "aws_route_table_association" "natRTAss" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.vpcPrivateSubnet[count.index].id
  route_table_id = aws_route_table.natRT.id
}
