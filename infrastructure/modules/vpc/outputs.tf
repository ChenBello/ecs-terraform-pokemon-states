output "vpc_id" {
    description = "The ID of the VPC"
    value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
    description = "The IDs of the public subnets"
    value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
    description = "The IDs of the private subnets"
    value       = module.vpc.private_subnets
}

output "public_subnet_1_id" {
  description = "The ID of the first public subnet"
  value       = length(module.vpc.public_subnets) > 0 ? module.vpc.public_subnets[0] : null
  sensitive = true
}

output "public_subnet_2_id" {
  description = "The ID of the second public subnet"
  value       = length(module.vpc.public_subnets) > 1 ? module.vpc.public_subnets[1] : null
  sensitive = true

}
output "private_subnet_1_id" {
  description = "The ID of the first private subnet"
  value       = length(module.vpc.private_subnets) > 0 ? module.vpc.private_subnets[0] : null
  sensitive = true
}

output "private_subnet_2_id" {
  description = "The ID of the second private subnet"
  value       = length(module.vpc.private_subnets) > 1 ? module.vpc.private_subnets[1] : null
  sensitive = true

}
