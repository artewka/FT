#Network module
module "vpc" {
  source = "./vpc"
}

#Creating instances with tags (srv variable)
 module "web" {
   source = "./ec2"

    count                        = 2
    subnet_id                    = element(module.vpc.private_subnet_ids[*],count.index)
    security_group               = [module.vpc.sg_web]
    user_data                    = false
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "web"
 }

  module "phpmyadmin" {
   source = "./ec2"

    count                        = 2
    subnet_id                    = element(module.vpc.private_subnet_ids[*],count.index)
    security_group               = [module.vpc.sg_web]
    user_data                    = false
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "phpmyadmin"

 }

   module "db" {
   source = "./ec2"
   
    subnet_id                    = module.vpc.db_subnet_ids
    security_group               = [module.vpc.sg_db]
    user_data                    = false
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "db"

    
 }
      
    module "bastion" {
    source = "./ec2"
   
    subnet_id                    = module.vpc.public_subnet_ids[0]
    security_group               = [module.vpc.sg_bastion]
    user_data                    = file("bastion.sh")
    key_name                     = aws_key_pair.ssh_key.key_name
    srv                          = "bastion"

    
 }
