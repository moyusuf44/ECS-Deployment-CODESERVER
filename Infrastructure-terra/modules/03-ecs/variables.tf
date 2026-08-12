variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "alb_security_group_id" {
  type = string
}

variable "code_server_password" {
  type = string 
  sensitive = true 
}

variable "cluster_name" {
  type = string
}

variable "image_id" {
  type = string 
}

variable "cpu" {
  type = string 
}

variable "memory" {
  type = string 
}

variable "desired_count" {
  type = string 
}

variable "subnets" {
  type = list(string)
}