output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "a list of the all public subnet "
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "a list of the all private subnets"
}

output "vpc_id" {
  value = module.vpc.vpc_id
  description = "The ID of the VPC"
}


output "account_id" {
  value = data.aws_caller_identity.account_id_pull.account_id
}