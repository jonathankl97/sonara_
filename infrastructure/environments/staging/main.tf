terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "sonara-tfstate-jonathan"
    key            = "staging/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "sonara-tf-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}