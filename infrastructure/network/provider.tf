provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Terraform   = "true"
      Environment = "Dev"
      Application = "Pokemon App"
    }
  }
}