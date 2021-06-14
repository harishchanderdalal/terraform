
##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}


#-------------------------------------------------------------------------- // Query for VPC Id
/* Find Vpc Id */
data "aws_vpc" "vpc" {
  tags = {
    Name = "devopsVpc"
  }
}

#-------------------------------------------------------------------------- // Query for Nat Gateway
/* Find Nat Gateway */
data "aws_nat_gateway" "natgateway" {
  tags = {
    Name = "devopsVpc-natGateway"
  }
}

#-------------------------------------------------------------------------- // Query for AMI App Layer
data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
