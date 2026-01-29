terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "6.30.0"
    }
    external = {
      source  = "registry.terraform.io/hashicorp/external"
      version = "2.3.5"
    }
    local = {
      source  = "registry.terraform.io/hashicorp/local"
      version = "2.6.1"
    }
    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "3.2.4"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.8.1"
    }
  }
}
