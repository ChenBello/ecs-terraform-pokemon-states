
terraform {
  backend "s3" {
    bucket         = "my-terraform-states-unique"
    key            = "network/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
