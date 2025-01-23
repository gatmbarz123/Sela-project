terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.55"
    }
  }

   backend "s3" {
    bucket = "terraform.sela.bucket1"
    key    = "tfstate.json"
    region = "eu-north-1"
  
  }

  required_version = ">= 1.7.0"
}

provider "aws" {
  region = var.aws_region  
}


module "vpc"{
    source  =   "./module/vpc"
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
    az = var.az
    cidr = var.cidr 
    vpc_name = var.vpc_name
    nat_gateway = var.nat_gateway
}

module "ec2"{
  source  =   "./module/ec2"
  instance_type = var.instance_type
  key_pairs = var.key_pairs
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  instacne_count = var.instacne_count
  alb_sg  = module.alb.alb_sg
}

module "alb"{
  source =  "./module/alb"
  alb_name  = var.alb_name
  lb_type   = var.lb_type
  deletion_protection   = var.deletion_protection
  logs_bucket   =   var.logs_bucket
  env = var.env

  tg_name = var.tg_name
  tg_port = var.tg_port
  tg_protocol = var.tg_protocol
  tg_attachment_port  = var.tg_attachment_port
  instance_id = module.ec2.instance_id

  listener_port = var.listener_port
  listener_protocol   =  var.listener_protocol
  listener_ssl_policy   =   var.listener_ssl_policy
  listener_ca   =   var.listener_ca
  listener_default_action_type    =   var.listener_default_action_type

  vpc_id  = module.vpc.vpc_id

  public_subnets = module.vpc.public_subnets

  route53_zone_name = var.route53_zone_name
  record_name = var.record_name
}

module "dynamodb"{
  source = "./module/dynamodb"
  dynamodb_name = var.dynamodb_name
  dydb_billing_mode = var.dydb_billing_mode
  dydb_attribute_name_1 = var.dydb_attribute_name_1
  dydb_attribute_name_2 = var.dydb_attribute_name_2
  dydb_attribute_type = var.dydb_attribute_type
  dydb_hash_key = var.dydb_hash_key
  env = var.env
}