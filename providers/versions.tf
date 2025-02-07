terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "5.86.0"
    }
    external = {
      source  = "registry.terraform.io/hashicorp/external"
      version = "2.3.4"
    }
    local = {
      source  = "registry.terraform.io/hashicorp/local"
      version = "2.5.2"
    }
    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "3.2.3"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.6.3"
    }
  }
}
