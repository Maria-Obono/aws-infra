terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 5.0"
      configuration_aliases = [ aws.src, aws.dst ]
    }
  }

  required_version = ">= 1.2.0"
}
