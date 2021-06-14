output "vpcid" {
  description = "The ID of the VPC"
  value       = data.aws_vpc.vpc.id
}

output "cidr" {
  description = "Cidr  of the VPC"
  value       = data.aws_vpc.vpc.cidr_block
}

output "subnetApp" {
  description = "Cidr  of the VPC"
  value       = aws_subnet.devApp
}


output "subnetData" {
  description = "Cidr  of the VPC"
  value       = aws_subnet.devData
}
