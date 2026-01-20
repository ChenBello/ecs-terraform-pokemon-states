
terraform {
  backend "s3" {
    bucket         = "my-terraform-states-unique-bucket"
    key            = "ecs/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-locks"
  }
}
