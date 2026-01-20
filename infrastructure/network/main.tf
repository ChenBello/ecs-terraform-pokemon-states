
module "vpc" {
  source             = "../modules/vpc"
  name               = "my-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["eu-west-1a", "eu-west-1b"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = true
  enable_vpn_gateway = false
  enable_dns_support   = true
  enable_dns_hostnames = true
  single_nat_gateway   = true # 1 For costs reduction
}

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   name    = "my-vpc"
#   cidr    = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support  = true

#   azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }
