module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.vpc_name
  cidr = var.cidr # 10.0.0.0/16
  map_public_ip_on_launch = true

  azs             = var.az # eu-north-1a , eu-north-1b
  public_subnets  = var.public_subnets # 10.0.1.0/24,10.0.2.0/24
  private_subnets    =  var.private_subnets # 10.0.3.0/24","10.0.4.0/24
  
  enable_nat_gateway = var.nat_gateway
}