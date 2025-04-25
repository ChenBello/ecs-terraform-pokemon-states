output "alb_arn_suffix" {
  value = aws_alb.application_load_balancer.arn_suffix
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.target_group.arn_suffix
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_alb.application_load_balancer.dns_name
}

