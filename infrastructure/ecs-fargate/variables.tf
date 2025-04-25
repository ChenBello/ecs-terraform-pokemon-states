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
