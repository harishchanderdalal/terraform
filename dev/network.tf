##################################################################################
# RESOURCES Network
##################################################################################

#-------------------------------------------------------------------------- // Subnet
/* App Subnet */
resource "aws_subnet" "devApp" {
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(data.aws_vpc.vpc.cidr_block, 9, 32 + count.index)
  vpc_id                  = data.aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.common_tags, { Name = "${var.environment_tag}App0${count.index + 1}" })
}

/* Data Subnet */
resource "aws_subnet" "devData" {
  count                   = var.subnet_count
  cidr_block              = cidrsubnet(data.aws_vpc.vpc.cidr_block, 9, 38 + count.index)
  vpc_id                  = data.aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(local.common_tags, { Name = "${var.environment_tag}Data0${count.index + 1}" })
}

#-------------------------------------------------------------------------- // RT for App with Nat
/* Dev RT with Nat */
resource "aws_route_table" "devNatRT" {
//  vpc_id = "${data.aws_vpc.vpc.id}"
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${data.aws_nat_gateway.natgateway.id}"
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-natRT" })
}

/* Dev RT Subnet Assocation */
resource "aws_route_table_association" "devNatRTAss" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.devApp[count.index].id
  route_table_id = aws_route_table.devNatRT.id
}

#-------------------------------------------------------------------------- // RT for Data Private
/* Dev RT with Nat */
resource "aws_route_table" "devPrivateRT" {
  vpc_id = data.aws_vpc.vpc.id
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-privateRT" })
}

/* Dev RT Subnet Assocation */
resource "aws_route_table_association" "devPrivateRTAss" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.devData[count.index].id
  route_table_id = aws_route_table.devPrivateRT.id
}
