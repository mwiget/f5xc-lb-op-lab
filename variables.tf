variable "project_prefix" {
  type        = string
  default     = "f5xc"
}

variable "owner_tag" {
  type        = string
  default     = "user@email"
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_ca_cert" {
  type = string
  default = ""
}

variable "f5xc_api_token" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type    = string
  default = "system"
}

variable "f5xc_reg_url" {
  type = string
  default = "ves.volterra.io"
}

variable "vsphere_server" {
  type = string
  default = ""
}
variable "vsphere_user" {
  type = string
  default = "administrator@vsphere.local"
}
variable "vsphere_password" {
  type = string
  default = ""
}
variable "vsphere_datacenter" {
  type = string
  default = ""
}
variable "vsphere_cluster" {
  type = string
  default = ""
}
variable "f5xc_ova_image" {
  type = string
  default = ""
}
variable "admin_password" {
  type = string
  default = ""
}
variable "vsphere_ubuntu_template" {
  type = string
  default = ""
}
variable "f5xc_vm_template" {
  type = string
  default = ""
}
variable "ssh_public_key" {
  type = string
  default = ""
}
