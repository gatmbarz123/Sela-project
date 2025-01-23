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

