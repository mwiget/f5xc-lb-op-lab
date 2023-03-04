terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = " 0.11.18"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.3.1"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.3.2"
    }
  }
}
