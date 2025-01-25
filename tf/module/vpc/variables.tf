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

variable "aws_region"{
    type    =   string
}

variable "app_sg"{
    type    = string
}

variable "vpc_endpoint_type"{
    type    =   string
}

variable "env"{
    type    =   string
}

variable "ecr_repo_name"{
    type = string
}

variable "ecr_scan_on_push" {
    type = string
}