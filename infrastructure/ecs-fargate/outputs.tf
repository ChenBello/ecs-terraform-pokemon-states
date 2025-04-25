# alb_dns_name
output "app_url" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.aws-alb-ecs.alb_dns_name
}

# output "ecs_cluster_id" {
#   value = module.ecs.cluster_id
# }

