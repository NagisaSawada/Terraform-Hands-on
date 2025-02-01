# ../../modules/以下にある各モジュールをデプロイ
module "vpc" {
  source = "../../modules/vpc"
}

module "ec2" {
  source                = "../../modules/ec2"
  allow_ssh             = true
  subnet_id             = module.vpc.public_subnet_ids[0]
  instance_profile_name = module.s3.s3_access_instance_profile_name
}

module "alb" {
  source                     = "../../modules/alb"
  subnet_ids                 = module.vpc.public_subnet_ids
  instance_id                = module.ec2.instance_id
  instance_security_group_id = module.ec2.instance_security_group_id
}

module "rds" {
  source                = "../../modules/rds"
  ec2_security_group_id = module.ec2.instance_security_group_id
  subnet_id             = module.vpc.private_subnet_ids[0]
  private_subnet_ids    = module.vpc.private_subnet_ids
}

module "s3" {
  source = "../../modules/s3"
}

