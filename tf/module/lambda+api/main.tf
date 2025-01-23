resource "aws_lambda_function" "lambda_fun" {
  filename      = "lambda_function.zip" #VAR lambda_filename
  function_name = "get_all" #VAR function_name
  role          = aws_iam_role.lambda_role.arn 
  handler       = "lambda_function.lambda_handler" #VAR lambda_handler

  runtime = "python3.9" #VAR runtime
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_sns_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_sns_policy" {
  name = "lambda_sns_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "execute-api:Invoke",
          "execute-api:ManageConnections"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem"
        ]
        Resource = "*"
      }
    ]
  })
}


