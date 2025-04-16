module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr_block
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  alb_target_group_arns = module.alb.target_group_arns
  ami = var.ec2_ami
  instance_type = var.ec2_instance_type
}
