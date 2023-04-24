terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "4.64.0"
    }
    external = {
      source  = "registry.terraform.io/hashicorp/external"
      version = "2.2.3"
    }
    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "3.1.1"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.4.3"
    }
  }
}
