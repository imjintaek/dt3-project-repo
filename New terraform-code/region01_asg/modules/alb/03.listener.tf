
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web.arn
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn   = "${var.certificate_arn}"  #
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"   #

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}