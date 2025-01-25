variable "lambda_filename"{
    type   = string
}

variable "function_name"{
    type = string
}

variable "lambda_handler"{
    type = string
}

variable "runtime" {
    type = string
}

variable "aws_region"{
    type = string
}

variable "dynamodb_arn"{
    type = string
}

variable "timeout_lambda"{
    type = string
}