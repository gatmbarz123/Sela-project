output "dynamodb_name"{
  value = aws_dynamodb_table.dynamodb_app.name
  description = "The name of ths DB"
}

output "dynamodb_arn"{
  value = aws_dynamodb_table.dynamodb_app.arn
}