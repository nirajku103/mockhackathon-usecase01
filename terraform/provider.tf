terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket-u2"
    key            = "terraform/statefile.tfstate"
    region         = "us-east-1"
  #  dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}