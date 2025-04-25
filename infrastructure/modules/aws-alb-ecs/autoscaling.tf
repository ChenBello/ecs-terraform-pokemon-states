#################################################################################################
# This file describes the ECS Auto Scaling configuration: Target, CPU policy, ALB requests policy
#################################################################################################

# Defines the scalable target for the ECS service (min/max capacity and scaling dimension)
resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Auto Scaling policy based on ECS service average CPU utilization
resource "aws_appautoscaling_policy" "cpu_policy" {
  name               = "${var.app_name}-cpu-scaling-policy"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 50.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 30
  }
}

# Auto Scaling policy based on number of ALB requests per target
resource "aws_appautoscaling_policy" "alb_requests_policy" {
  name               = "${var.app_name}-alb-requests-scaling-policy"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_alb.application_load_balancer.arn_suffix}/${aws_lb_target_group.target_group.arn_suffix}"
    }
    target_value       = 100.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 30
  }
}
