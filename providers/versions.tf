terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "6.14.1"
    }
    external = {
      source  = "registry.terraform.io/hashicorp/external"
      version = "2.3.5"
    }
    local = {
      source  = "registry.terraform.io/hashicorp/local"
      version = "2.5.3"
    }
    null = {
      source  = "registry.terraform.io/hashicorp/null"
      version = "3.2.4"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "3.7.2"
    }
  }
}
