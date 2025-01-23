output "instance_id" {
  value = aws_instance.app[*].id
  description = "The ID of the example EC2 instance."
}