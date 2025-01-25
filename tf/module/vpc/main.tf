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
      "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.account_id_pull.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com >> /home/ec2-user/debug.log 2>&1",
      "sudo yum install -y docker",
      "sudo usermod -aG docker ec2-user",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo docker pull ${data.aws_caller_identity.account_id_pull.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo_name}:${var.image_tag} >> /home/ec2-user/debug.log 2>&1",
      "sudo docker run -d -e AWS_REGION=${var.aws_region} -e DYNAMODB_TABLE=${var.dynamodb_name} -p 5000:5000 ${data.aws_caller_identity.account_id_pull.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo_name}:${var.image_tag}"
    ])
  }
}


#-----------------------------------------------------------------------------ECR


