# ALB 

variable alb_name {
  type        = string
}

variable "lb_type"{
    type = string 
}

variable "public_subnets"{
    type = list 
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

# Target_group 

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

variable "instance_id"{
  type  = list
}


variable "health_check_protocol"{
    type = string
}

variable "health_check_interval"{
    type = string
}

variable "health_check_timeout"{
    type = string 
}

variable "healthy_threshold_count"{
    type = string 
}

variable "unhealthy_threshold_count"{
    type = string 
}

variable "matcher"{
    type = string
}

variable "path_health_check"{
    type = string
}

#LB_listener

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

# SG 

variable "vpc_id"{
    type = string 
}



#Route 53

variable "route53_zone_name"{
    type = string 
}

variable "record_name"{
    type = string 
}