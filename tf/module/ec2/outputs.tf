output "instance_id" {
  value = aws_instance.app[*].id
  description = "The ID of the example EC2 instance."
}

output "app_sg"{
  value = aws_security_group.app_sg.id
  description = "For the SSM"
}