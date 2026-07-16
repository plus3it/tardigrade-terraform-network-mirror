terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "6.55.0"
    }
    external = {
      source  = "registry.terraform.io/hashicorp/external"
      version = "2.4.0"
    }
    local = {
      source  = "registry.terraform.io/hashicorp/local"
      version = "2.9.0"
    }
    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "3.3.0"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.9.0"
    }
  }
}
