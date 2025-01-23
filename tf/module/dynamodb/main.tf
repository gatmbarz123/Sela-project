resource "aws_dynamodb_table" "dynamodb_app" {
    name         = var.dynamodb_name
    billing_mode = var.dydb_billing_mode #"PAY_PER_REQUEST" 
    
    attribute {
        name = var.dydb_attribute_name_1  # "ServiceName" 
        type = var.dydb_attribute_type              # "S" 
    }

    attribute {
        name = var.dydb_attribute_name_2  # "Region" 
        type = var.dydb_attribute_type    # "S" 
    }

    hash_key = var.dydb_hash_key # "ServiceName" 

    tags  = {
    Environment = var.env 
  }
}