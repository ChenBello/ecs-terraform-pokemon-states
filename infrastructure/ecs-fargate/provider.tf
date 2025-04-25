provider "aws" {
  region = var.region # "us-east-1"
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "Dev"
      Application = "Pokemon App"
    }
  }
}