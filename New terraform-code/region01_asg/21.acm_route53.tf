resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "cpe.skdt.io"                       #OWN  DOMAIN NAME   
  validation_method = "DNS"
  tags = {
    Environment = "dt-level3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300              #300
  type            = each.value.type
  zone_id         = "Z030908817YVOCAK1PMEP"                        #OWN  Hosted Zone ID       aws_route53_zone.hosted_zone
}



resource "aws_route53_record" "www" {
  zone_id = "Z030908817YVOCAK1PMEP"                        #OWN  Hosted Zone ID       aws_route53_zone.hosted_zone
  name    = "example.cpe.skdt.io"
  type    = "A"

  alias {
      name                   = format("%s%s","dualstack.",module.load_balancer.web_alb_dns_name) #module.load_balancer.web_alb_dns_name
      zone_id                = module.load_balancer.web_alb_zone_id
      evaluate_target_health = true
      }
        weighted_routing_policy {
        weight = 100
      }
  set_identifier = "1"
  depends_on              =   [ module.load_balancer ]  

}


