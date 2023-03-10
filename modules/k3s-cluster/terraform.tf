terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.110.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}
