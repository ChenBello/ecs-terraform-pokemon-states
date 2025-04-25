variable "vpc_id" {
    description = "The ID of the VPC"
    type       = string
}

variable "region" {
  description = "Main region for all resources"
  type        = string
}

variable "app_name" {
  description = "The name of the containerized application"
  type        = string
}

variable "public_subnet_1_id" {
   type        = string
   description = "ID of public subnet 1"
}
variable "public_subnet_2_id" {
   type        = string
   description = "ID of public subnet 2"
}
variable "private_subnet_1_id" {
   type        = string
   description = "ID of private subnet 1"
}
variable "private_subnet_2_id" {
   type        = string
   description = "ID of private subnet 2"
}


variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}


# variable "default_tags" {
#   description = "Default tags for all resources"
#   type        = map(string)
#   default = {
#     Terraform   = "true"
#     Environment = "Dev"
#     Application = "Pokemon App"
#   }
# }

variable "container_port" {
   type = number
   description = "Port that needs to be exposed for the application"
   default = 5000
}

variable "container_image" {
  type        = string
  description = "Docker image to run"
  default     = "chenbello3/pokemon-flask-app:latest" # image from Docker Hub 
}


