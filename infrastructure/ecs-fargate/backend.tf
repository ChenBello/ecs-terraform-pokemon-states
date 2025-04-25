
terraform {
  backend "s3" {
    bucket         = "my-terraform-states-unique"
    key            = "ecs/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
