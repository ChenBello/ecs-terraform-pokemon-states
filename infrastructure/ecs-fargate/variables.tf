variable "region" {
  description = "Main region for all resources"
  type        = string
}

variable "app_name" {
  type        = string
  description = "Name of the application"
  default     = "pokemon"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}

variable "container_image" {
  type        = string
  description = "Docker image to run"
  default     = "chenbello3/pokemon-flask-app:latest"
}

# Monitoring Variables

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "alert_email" {
  description = "Email address for alerts (requires confirmation)"
  type        = string
}

variable "error_threshold" {
  description = "Number of ERROR log entries to trigger alarm"
  type        = number
  default     = 10
}

variable "exception_threshold" {
  description = "Number of Exception log entries to trigger alarm"
  type        = number
  default     = 5
}

variable "cpu_threshold" {
  description = "CPU utilization percentage threshold"
  type        = number
  default     = 80
}

variable "memory_threshold" {
  description = "Memory utilization percentage threshold"
  type        = number
  default     = 80
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}


# variable "public_subnet_ids" {
#   description = "List of public subnet IDs"
#   type        = list(string)
# }

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }

# variable "cluster_name" {
#   description = "The name of the ECS cluster."
#   type        = string
#   default     = "pokemon-cluster"
# }

# variable "default_tags" {
#   type = map(string)
#   description = "Default tags to apply to resources"
#   default = {
#     Terraform   = "true"
#     Application = "Pokemon App"
#     Environment = "Dev"
#   }
# }
