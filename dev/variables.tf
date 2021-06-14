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

#-------------------------------------------------------------------------- // Subnet
/* Number of Subnet */
variable "subnet_count" {
  default = 2
}

#-------------------------------------------------------------------------- // Ec2
/* Number of Instance */
variable "instance_count" {
  default = 1
}

variable "instance_size" {
  default = "t2.micro"
}

variable "volume_size" {
  default = "30"
}

variable "volume_type" {
  default = "standard"
}

#-------------------------------------------------------------------------- // Comman Tag
variable "account_tag" {
  default = "devops"
}

variable "environment_tag" {
  default = "dev"
}
