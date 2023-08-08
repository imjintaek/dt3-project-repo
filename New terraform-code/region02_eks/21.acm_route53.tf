resource "aws_acm_certificate" "acm_cert" {
  domain_name       = "cpe.skdt.io"                                #OWN  DOMAIN NAME  
  validation_method = "DNS"
  tags = {
    Environment = "dt-level3"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.acm_cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 300              #300
#   type            = each.value.type
#   zone_id         = "Z008250672MICSXRSFQM"                        #labthink.shop Hosted Zone ID       aws_route53_zone.hosted_zone
# }

# # resource "aws_route53_record" "cert_validation" {
# #   name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
# #   records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
# #   ttl     = 60
# #   type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
# #   zone_id = data.aws_route53_zone.front.zone_id
# # }





# # resource "aws_route53_zone" "hosted_zone" {                        #aws dns서버를 가비아 nameserver 에 등록후 전파에 시간이 소요 되어 사전 생성함함 
# #   name          = "testdtms.shop"
# #   force_destroy = true
# # }
# # output "name_server" {
# #   value = aws_route53_zone.hosted_zone.name_servers
# # }




# #ALB 정보 추가
# resource "aws_route53_record" "www" {
#   zone_id = "Z06306101WVNVGYCMLN5C"                                #testdtms.shop Hosted Zone ID
#   name    = "*.testdtms.shop"
#   type    = "A"

#   alias {
#     name                   = module.load_balancer.web_alb_dns_name                 #module.load_balancer.web_alb_dns_name
#     zone_id                = module.load_balancer.web_alb_zone_id                  #module.load_balancer.web_alb_zone_id
#     evaluate_target_health = true
#   }
#     depends_on              =   [ module.auto_scaling_group ]  
# }

# resource "aws_route53_record" "www" {
#   zone_id = "${data.aws_route53_zone.selected.zone_id}""
#   name    = "www.${data.aws_route53_zone.selected.name}"
#   type    = "A"
#   ttl     = "300"
#   records = ["10.0.0.1"]
# }

