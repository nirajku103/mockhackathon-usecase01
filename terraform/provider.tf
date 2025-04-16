terraform {
  backend "s3" {
    bucket         = "mock-hackathon-uc01"
    key            = "terraform/"
    region         = "eu-north-1"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-north-1"
}