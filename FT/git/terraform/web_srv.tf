
module "vpc" {
  source = "./vpc"
}

 module "web" {
   source = "./ec2"

    count                        = 2
    subnet_id                    = element(module.vpc.public_subnet_ids[*],count.index)
    security_group               = [module.vpc.sg_public]
    user_data                    = false
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "web"
 }

  module "phpmyadmin" {
   source = "./ec2"

    count                        = 2
    subnet_id                    = element(module.vpc.private_subnet_ids[*],count.index)
    security_group               = [module.vpc.sg_public]
    user_data                    = false
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "phpmyadmin"

 }

   module "db" {
   source = "./ec2"
   
    subnet_id                    = module.vpc.db_subnet_ids
    security_group               = [module.vpc.sg_private]
    user_data                    = false
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "db"

    
 }
