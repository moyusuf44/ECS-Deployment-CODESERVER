variable "zone_name" {
  type = string
}
variable "domain_validation_options" {

  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
} 

variable "alb_dns_name" {
  type = string 
}

variable "zone_id" {
  type = string
}