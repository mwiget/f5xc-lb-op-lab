module "vsphere1" {
  source                = "./modules/f5xc/ce/vsphere"
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_namespace        = var.f5xc_namespace
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_ca_cert      = var.f5xc_api_ca_cert
  f5xc_reg_url          = var.f5xc_reg_url
  #  f5xc_ova_image        = var.f5xc_ova_image
  f5xc_vm_template      = var.f5xc_vm_template
  vsphere_user          = var.vsphere_user
  vsphere_password      = var.vsphere_password
  vsphere_server        = var.vsphere_server
  vsphere_datacenter    = var.vsphere_datacenter
  vsphere_cluster       = var.vsphere_cluster
  admin_password        = var.admin_password
  custom_labels         = {
    "site-mesh" = var.project_prefix
  }
  nodes   = [
    { name = "master-0", host = "192.168.40.100", datastore = "datastore3", ipaddress = "192.168.40.171/24" }
  ]
  outside_network       = "VM Network"
  dnsservers            = {
    primary = "8.8.8.8"
    secondary = "8.8.4.4"
  }
  publicdefaultgateway  = "192.168.40.1"
  publicdefaultroute    = "0.0.0.0/0"
  guest_type            = "centos64Guest"
  cpus                  = 4
  memory                = 14336
  certifiedhardware     = "vmware-voltmesh"
  cluster_name          = format("%s-vsphere1", var.project_prefix)
  sitelatitude          = "50.1"
  sitelongitude         = "8.6"
}

module "vsphere2" {
  source                = "./modules/f5xc/ce/vsphere"
  f5xc_tenant           = var.f5xc_tenant
  f5xc_api_url          = var.f5xc_api_url
  f5xc_namespace        = var.f5xc_namespace
  f5xc_api_token        = var.f5xc_api_token
  f5xc_api_ca_cert      = var.f5xc_api_ca_cert
  f5xc_reg_url          = var.f5xc_reg_url
  #f5xc_ova_image        = var.f5xc_ova_image
  f5xc_vm_template      = var.f5xc_vm_template
  vsphere_user          = var.vsphere_user
  vsphere_password      = var.vsphere_password
  vsphere_server        = var.vsphere_server
  vsphere_datacenter    = var.vsphere_datacenter
  vsphere_cluster       = var.vsphere_cluster
  admin_password        = var.admin_password
  custom_labels         = {
    "site-mesh" = var.project_prefix
  }
  nodes   = [
    { name = "master-0", host = "192.168.40.100", datastore = "datastore3", ipaddress = "192.168.40.172/24" }
  ]
  outside_network       = "VM Network"
  dnsservers            = {
    primary = "8.8.8.8"
    secondary = "4.4.4.4"
  }
  publicdefaultgateway  = "192.168.40.1"
  publicdefaultroute    = "0.0.0.0/0"
  guest_type            = "centos64Guest"
  cpus                  = 4
  memory                = 14336
  certifiedhardware     = "vmware-voltmesh"
  cluster_name          = format("%s-vsphere2", var.project_prefix)
  sitelatitude          = "52.3"
  sitelongitude         = "4.8"
}

output "vsphere1" {
  value = module.vsphere1
}
output "vsphere2" {
  value = module.vsphere2
}
