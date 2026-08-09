module "vpc" {
    source = "./modules/01-vpc"
 
}

module "ecs" {
    source = "./modules/03-ecs"

    target_group_arn = module.alb.target_group
    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.public_subnets
    subnets = module.vpc.public_subnets
    security_group = module.vpc.ecs_security_group_id
    alb_security_group_id = module.alb.alb_security_group_id
   
    cluster_name = var.cluster_name
    code_server_password = var.code_server_password
    image_id = var.image_id
    cpu = var.cpu
    memory = var.memory
    desired_count = var.desired_count
}

module "alb" {  
    source = "./modules/04-alb"
  
    vpc_id = module.vpc.vpc_id
    subnets = module.vpc.public_subnets
    certificate_arn = module.acm.certificate_arn
    
    health_check_path = var.health_check_path
}

module "acm" {
    source = "./modules/05-acm"

    domain_name = var.domain_name
    subdomain = var.subdomain
    zone_id = var.zone_id
}

module "cloudflare" {
    source = "./modules/06-cloudflare"

    
    domain_validation_options = module.acm.domain_validation_options
    alb_dns_name = module.alb.alb_dns_name
   
    zone_name = var.zone_name
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = module.acm.certificate_arn

  validation_record_fqdns = module.cloudflare.validation_record_fqdns

  depends_on = [
    module.cloudflare
  ]
}