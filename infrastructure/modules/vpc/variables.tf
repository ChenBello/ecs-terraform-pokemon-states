variable "name" {
    type        = string
    description = "Name to be used on all the resources as an identifier."
}

variable "cidr" {
    type        = string
    description = "(Optional) The IPv4 CIDR block for the VPC."
    default     = "10.0.0.0/16"
}

variable "azs" {
    type        = list(string)
    description = "A list of availability zones names or ids in the region."
    
}

variable "private_subnets" {
    type        = list(string)
    description = "A list of private subnets inside the VPC."
}

variable "public_subnets" {
    type        = list(string)
    description = "A list of public subnets inside the VPC."
}

variable "enable_nat_gateway" {
    type        = bool
    description = "Whether to enable NAT gateway."
    default     = true
}

variable "enable_vpn_gateway" {
    type        = bool
    description = "Whether to enable VPN gateway."
    default     = false
}

variable "enable_dns_hostnames" {
    type        = bool
    description = "Whether to enable DNS host names."
    default     = true
}

variable "enable_dns_support" {
    type        = bool
    description = "Whether to enable DNS support."
    default     = true
}
