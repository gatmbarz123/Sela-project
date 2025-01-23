# -----------------------------VPC

variable "aws_region"{
    type = string
}

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

#-------------------------------------------EC2

variable "instacne_count"{
  type  = string
}

variable "key_pairs" {
   description = "key_name"
   type        = string

}

variable "instance_type" {
   description = "instance_type"
   type        = string

}


#---------------------------------------ALB

variable alb_name {
  type        = string
}

variable "lb_type"{
    type = string 
}

variable "deletion_protection"{
    type = string 
}

variable "logs_bucket"{
    type = string 
}

variable "env"{
    type = string 
}

#----------------------Target_group 

variable "tg_name"{
    type = string 
}

variable "tg_port"{
    type = string 
}

variable "tg_protocol"{
    type = string 
}

variable "tg_attachment_port"{
    type = string 
}

#-----------------LB_listener

variable "listener_port"{
    type = string 
}

variable "listener_protocol"{
    type = string 
}

variable "listener_ssl_policy"{
    type = string 
}

variable "listener_ca" {
    type = string
}

variable "listener_default_action_type"{
    type = string 
}

#------------------- Route 53

variable "route53_zone_name"{
    type = string 
}

variable "record_name"{
    type = string 
}

#----------------------DynamoDB

variable "dynamodb_name" {
    type = string
}

variable "dydb_billing_mode"{
    type = string 
}

variable "dydb_attribute_name_1"{
    type = string 
}

variable "dydb_attribute_name_2"{
    type = string 
}

variable "dydb_attribute_type"{
    type = string 
}

variable "dydb_hash_key"{
    type = string 
}

