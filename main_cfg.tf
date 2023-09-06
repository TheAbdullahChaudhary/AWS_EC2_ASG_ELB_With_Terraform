# -----------------------------------------step 1 provider-----------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# -----------------------------------------step 2 provider configuration-----------------------------------------

provider "aws" {
  region     = "ap-southeast-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}



