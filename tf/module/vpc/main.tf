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



#----------------------------------------------VPC

#----------------------------------------------SSM


resource "aws_vpc_endpoint" "ssm" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type  = var.vpc_endpoint_type #"Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [var.app_sg]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type  = var.vpc_endpoint_type #"Interface"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [var.app_sg]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id             = module.vpc.vpc_id
  service_name       = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type  = var.vpc_endpoint_type 
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [var.app_sg]
}


resource "aws_ssm_association" "ssm-script" {
  name = "AWS-RunShellScript"

  targets {
    key    = "tag:Environment"
    values = [var.env]
  }

  parameters = {
    commands = join("\n", [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker pull diskoproject/sela-image1",
      "sudo docker run -d -p 5000:5000 diskoproject/sela-image1"
    ])
  }
}


#-----------------------------------------------------------------------------ECR

resource "aws_ecr_repository" "my_repository" {
  name                 = var.ecr_repo_name  #service_outputs
  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push  # true 
  }
}
