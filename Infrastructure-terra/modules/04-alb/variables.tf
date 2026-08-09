variable "certificate_arn" {
  type = string
}

variable "health_check_path" {
  type = string 
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}