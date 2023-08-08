###############################################################################
resource "aws_sns_topic" "asg_updates" {
  name = "${var.prefix}-sns-topic"
}

resource "aws_sns_topic_subscription" "web_updates_sqs_target" {
  topic_arn = aws_sns_topic.asg_updates.arn
  protocol  = "email"
  endpoint  = "${var.sns_email_address}"      # personal email to receive sns alarm
}