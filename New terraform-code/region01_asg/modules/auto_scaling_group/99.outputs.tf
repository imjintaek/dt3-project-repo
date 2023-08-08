output "web_auto_scaling_group_id" {
    description     =   "The ID of Auto Scaling Group"
    value           =   aws_autoscaling_group.web.id
}

output "web_launch_configuration_id" {
    description     =   "The ID of Launch Configuration"
    value           =   aws_launch_configuration.web.id
}