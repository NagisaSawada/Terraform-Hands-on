# ../../modules/以下にある各モジュールをデプロイ
module "vpc" {
  source               = "../../modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_args   = var.public_subnet_args
  private_subnet_args  = var.private_subnet_args
  resource_name_suffix = var.resource_name_suffix
}

module "ec2" {
  source                = "../../modules/ec2"
  key_name              = var.key_name
  ssh_cidr_blocks       = var.ssh_cidr_blocks
  allow_ssh             = true
  subnet_id             = module.vpc.public_subnet_ids[0]
  instance_profile_name = module.s3.s3_access_instance_profile_name
  resource_name_suffix  = var.resource_name_suffix
}

module "alb" {
  source                     = "../../modules/alb"
  subnet_ids                 = module.vpc.public_subnet_ids
  instance_id                = module.ec2.instance_id
  instance_security_group_id = module.ec2.instance_security_group_id
  resource_name_suffix       = var.resource_name_suffix
}

module "rds" {
  source                = "../../modules/rds"
  db_identifier         = var.db_identifier
  username              = var.username
  ec2_security_group_id = module.ec2.instance_security_group_id
  subnet_id             = module.vpc.private_subnet_ids[0]
  private_subnet_ids    = module.vpc.private_subnet_ids
  resource_name_suffix  = var.resource_name_suffix
}

module "s3" {
  source                = "../../modules/s3"
  bucket_name           = var.bucket_name
  policy_name           = var.policy_name
  role_name             = var.role_name
  instance_profile_name = var.instance_profile_name
  resource_name_suffix  = var.resource_name_suffix
}

