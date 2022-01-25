output "vpc_public_subnet" {
  value = module.vpc.public_subnet_ids[*]
}

output "vpc_private_subnet" {
  value = module.vpc.private_subnet_ids[*]
}

output "db_subnet_ids" {
  value = module.vpc.db_subnet_ids
}

output "sg_public_srv" {
  value = module.vpc.sg_public
}

output "sg_private_srv" {
  value = module.vpc.sg_private
}

output "bastion" {
  value = module.vpc.bastion
}

output "vpc_cidr_id" {
  value = module.vpc.vpc_cidr_id
}

output "aws_web_instance_id" {
  value = module.web[*].aws_instance_id
}

output "aws_db_instance_id" {
  value = module.db[*].aws_instance_id
}

output "green_alb_dns" {
  value = aws_lb.green.dns_name
}

output "blue_alb_dns" {
  value = aws_lb.blue.dns_name
}
  
output "db_ip" {
  value = module.db.public_ip
}
