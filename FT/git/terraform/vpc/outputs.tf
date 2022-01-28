#Public subnet ids
output "public_subnet_ids" {
  description = "subnet ID"
  value       = aws_subnet.Public[*].id
}

#Private subnet ids
output "private_subnet_ids" {
  description = "subnet ID"
  value       = aws_subnet.Private[*].id
}

#DB subnet ids
output "db_subnet_ids" {
  description = "subnet ID"
  value       = aws_subnet.DB.id
}

#VPC id
output "vpc_cidr_id" {
  value       = aws_vpc.Vpc_Ter.id
}

#Security group id for public subnet
output "sg_web" {
  value = aws_security_group.web_srv.id
}

#Security group id for private subnet
output "sg_db" {
  value = aws_security_group.db_srv.id
}

#Security group id for bastion subnet
output "sg_bastion" {
  value = aws_security_group.bastion_srv.id
}
