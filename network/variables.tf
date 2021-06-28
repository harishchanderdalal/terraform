##################################################################################
# VARIABLES
##################################################################################

#-------------------------------------------------------------------------- // Aws Details
variable "awsAccessKey" {
    type = string
//  default = "XX"
}
variable "awsSecretKey" {
    type = string
//  default = "XX"
}

variable "region" {
  default = "ap-south-1"
}

#-------------------------------------------------------------------------- // Vpc
/* Vpc Cidr */
variable "vpcCidr" {
    type = string
//  default = "10.20.0.0/16"
}

/* Number of Subnet */
variable "subnet_count" {
  default = 2
}

#-------------------------------------------------------------------------- // Comman Tag
variable "account_tag" {
  default = "devops"
}

variable "environment_tag" {
  default = "devopsVpc"
}
