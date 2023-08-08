resource "aws_autoscaling_policy" "web_scaling_policy" {
  name                      = "${var.prefix}-web-scaling-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  autoscaling_group_name    = aws_autoscaling_group.web.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
 
    }
    
    target_value = "40" #ASGAverageCPUUtilization CPU 10%
    #target_value = "1" #ALBRequestCountPerTarget Request 1
  }
}


resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_up" {
  alarm_name = "web_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "70"

  #dimensions {
  #  AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  #}

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [aws_autoscaling_policy.web_scaling_policy.arn]
}

##### 4 분 내 2개의 데이터 포인트에 대한 CPUUtilization >= 70
























