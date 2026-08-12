data "cloudflare_zone" "this" {
    filter = {
        name = var.zone_name
    }
}

resource "cloudflare_dns_record" "acm_validation" {

 for_each = {
  for idx, dvo in var.domain_validation_options :
  idx => dvo
}

  zone_id = var.zone_id

  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  content = each.value.resource_record_value

  ttl = 60

  proxied = false
}

resource "cloudflare_dns_record" "app" {
  zone_id = data.cloudflare_zone.this.id

  name = "tm"
  type = "CNAME"
  content = var.alb_dns_name

  proxied = true
  ttl = 1
}

resource "cloudflare_dns_record" "root_app" {
  zone_id = data.cloudflare_zone.this.id

  name = "@"
  type = "CNAME"
  content = var.alb_dns_name

  proxied = true
  ttl = 1
}


