resource "aws_autoscaling_group" "web" {
    name                         =    "${var.prefix}-web"
    vpc_zone_identifier          =    var.subnet_ids
    max_size                     =    var.max_size	
    min_size                     =    var.min_size
    desired_capacity             =    var.desired_capacity
    target_group_arns            =    var.target_group_arns

    health_check_type            =    "ELB"


    launch_configuration = aws_launch_configuration.web.name


    enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
    metrics_granularity="1Minute"

   # Required to redeploy without an outage.
    lifecycle {
    create_before_destroy = true
  }
    
    tag {
      key = "Name"
      value = "${var.prefix}-alb-autoscaling-instance"
      propagate_at_launch = true
  }
    tag {
      key = "team"
      value = "${var.tags.team}"
      propagate_at_launch = true
  }
    
}

################################################################################################################
resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [aws_autoscaling_group.web.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.asg_updates.arn
}


