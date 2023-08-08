output "web_alb_arn" {
    description     =   "The ARN of ALB"
    value           =   aws_lb.web.arn
}

output "web_alb_arn_suffix" {
    description     =   "The ARN suffix of ALB"
    value           =   aws_lb.web.arn_suffix
}

output "web_alb_name" {
    description     =   "The name of ALB"
    value           =   aws_lb.web.name
}

output "web_alb_dns_name" {
    description     =   "The DNS name of ALB"
    value           =   aws_lb.web.dns_name
}

output "web_alb_zone_id" {
    description     =   "The zone ID of ALB"
    value           =   aws_lb.web.zone_id
}


output "web_target_group_id" {
    description     =   "The ID of Target Group for ALB"
    value           =   aws_lb_target_group.web.id
}

output "web_target_group_arn" {
    description     =   "The ARN of Target Group for ALB"
    value           =   aws_lb_target_group.web.arn
}

output "web_target_group_arn_suffix" {
    description     =   "The ARN suffix of Target Group for ALB"
    value           =   aws_lb_target_group.web.arn_suffix
}
