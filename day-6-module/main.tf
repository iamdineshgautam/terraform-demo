module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_1_cidr = "10.0.0.0/24"
  public_subnet_1_az = "ap-south-1a"
  public_subnet_2_cidr = "10.0.1.0/24"
  public_subnet_2_az = "ap-south-1b"
  sg_name = "my_security_group"
}

module "lb" {
  source = "./modules/lb"
  vpc_id = module.vpc.vpc_id
  sg_id = module.vpc.sg_id
  public_subnet_1_id = module.vpc.public_subnet_1_id
  public_subnet_2_id = module.vpc.public_subnet_2_id
  lb_type = "application"
}

module "asg" {
  source = "./modules/asg"
  image_id = ""
  key_name = "u-key"
  instance_type = "t3.micro"
  sg_id = module.vpc.sg_id
  desired_capacity = 2
  max_size = 5
  min_size = 2
  target_arn = module.lb.target_group_arn
  public_subnet_1 = module.vpc.public_subnet_1_id
  public_subnet_2 = module.vpc.public_subnet_2_id
}