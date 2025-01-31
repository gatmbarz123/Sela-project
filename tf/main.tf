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

    
    app_sg    = module.ec2.app_sg
    vpc_endpoint_type = var.vpc_endpoint_type
    dynamodb_name = module.dynamodb.dynamodb_name

    ecr_repo_name = var.ecr_repo_name
    image_tag = var.image_tag

    aws_region  = var.aws_region
    env = var.env
}

module "ec2"{
  source  =   "./module/ec2"
  instance_type = var.instance_type
  key_pairs = var.key_pairs
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets
  instacne_count = var.instacne_count
  alb_sg  = module.alb.alb_sg
  path_private_key  = var.path_private_key
  dynamodb_arn  = module.dynamodb.dynamodb_arn
  env = var.env
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
  health_check_protocol = var.health_check_protocol
  health_check_interval = var.health_check_interval
  health_check_timeout  = var.health_check_timeout
  healthy_threshold_count = var.healthy_threshold_count
  unhealthy_threshold_count = var.unhealthy_threshold_count
  matcher  = var.matcher
  path_health_check = var.path_health_check

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

module "lambda"{
  source = "./module/lambda"
  lambda_filename = var.lambda_filename
  function_name = var.function_name
  lambda_handler  = var.lambda_handler
  runtime = var.runtime
  aws_region  = var.aws_region
  dynamodb_arn  = module.dynamodb.dynamodb_arn
  timeout_lambda  = var.timeout_lambda

  depends_on = [module.vpc , module.dynamodb , module.alb , module.ec2 ]
}