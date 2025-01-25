variable "aws_region"{
    type    =   string
}
variable "env"{
    type    =   string
}

#VPC

variable "private_subnets"{
    type    = list(string)
}

variable "public_subnets"{
    type    = list(string)   
}

variable "az"{
    type    = list(string)
}

variable "cidr"{
    type    = string
}

variable "vpc_name"{
    type    = string
}

variable "nat_gateway"{
    type    =  string
}

#SSM

variable "app_sg"{
    type    = string
}

variable "vpc_endpoint_type"{
    type    =   string
}

variable "dynamodb_name"{
    type = string 
}

variable "image_tag"{
    type = string
}


#ECR 
variable "ecr_repo_name"{
    type = string
}





