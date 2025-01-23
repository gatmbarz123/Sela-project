variable "instance_type" {
   description = "instance_type"
   type        = string

}
variable "key_pairs" {
   description = "key_name"
   type        = string

}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string

}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string) 
}

variable "instacne_count"{
  type  = string
}

variable "alb_sg"{
  type = string 
}