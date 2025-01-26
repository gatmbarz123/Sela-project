## aws_region add in the github actions cicd 
## env = "prod" add in the github actions cicd

#VPC - VARS 
private_subnets = ["10.0.3.0/24","10.0.4.0/24"]
public_subnets = ["10.0.1.0/24","10.0.2.0/24"]
az = ["eu-north-1a","eu-north-1b"]
cidr = "10.0.0.0/16"
vpc_name = "App-VPC"
nat_gateway = true


#EC2 - VARS     
instance_type = "t3.micro"
key_pairs = "StockKey" 
instacne_count = 2
## path_private_key  add in the github actions cicd


#ALB - VARS     
alb_name = "alb-app"
lb_type = "application"
deletion_protection = false
logs_bucket = "alb.polybot.logs"

tg_name = "tg-alb-telegram"
tg_port = 5000 
tg_protocol = "HTTP"
tg_attachment_port = 5000
health_check_protocol = "HTTP"
health_check_interval = 30
health_check_timeout  = 5
healthy_threshold_count = 3
unhealthy_threshold_count = 2
path_health_check = "/health"
matcher = 200

listener_port = 443 
listener_protocol = "HTTPS"
listener_ssl_policy =  "ELBSecurityPolicy-2016-08"
## listener_ca add in the github actions cicd
listener_default_action_type = "forward" 

route53_zone_name = "bargutman.click"
record_name = "sela.bargutman.click"

#DynamoDB - VARS
dynamodb_name = "App_Table"
dydb_billing_mode = "PAY_PER_REQUEST"
dydb_attribute_name_1 = "ServiceName"
dydb_attribute_name_2 = "Region" 
dydb_attribute_type = "S"
dydb_hash_key = "ServiceName"

#Lambda - VARS
lambda_filename = "lambda_function.zip"
function_name = "get_all"
lambda_handler  = "lambda_function.lambda_handler"
runtime = "python3.9"
timeout_lambda = 15

#SSM - VARS 
vpc_endpoint_type = "Interface"
## image_tag add in the github actions cicd
 
#ECR - VARS 
## ecr_repo_name  add in the github actions cicd
