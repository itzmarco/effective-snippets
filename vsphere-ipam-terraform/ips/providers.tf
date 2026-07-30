terraform {
  required_providers {
    phpipam = {
      source  = "Ouest-France/phpipam"
      version = "0.6.0"
    }
  }
}

provider "phpipam" {
  app_id   = var.phpipam_app_id
  endpoint = "http://${var.phpipam_address}/api"
  password = var.phpipam_password
  username = var.phpipam_user
  insecure = true
}

