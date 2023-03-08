data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "ubuntu_template" {
  name = var.vsphere_ubuntu_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

locals {
  templatevars = {
    #name = "${var.project_prefix}-ubuntu"
    ssh_public_key   = var.ssh_public_key
  }
}

# see https://www.terraform.io/docs/providers/vsphere/r/virtual_machine.html
resource "vsphere_virtual_machine" "ubuntu" {
  name = "${var.project_prefix}-ubuntu"
  guest_id = data.vsphere_virtual_machine.ubuntu_template.guest_id
  firmware = data.vsphere_virtual_machine.ubuntu_template.firmware
  num_cpus = 1
  num_cores_per_socket = 1
  memory = 2048
  nested_hv_enabled = true
  vvtd_enabled = true
  enable_disk_uuid = true # NB the VM must have disk.EnableUUID=1 for, e.g., k8s persistent storage.
  resource_pool_id = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
  scsi_type = data.vsphere_virtual_machine.ubuntu_template.scsi_type
  cdrom {
    client_device = true
  }
  disk {
    unit_number = 0
    label = "os"
    size = data.vsphere_virtual_machine.ubuntu_template.disks.0.size
    eagerly_scrub = data.vsphere_virtual_machine.ubuntu_template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.ubuntu_template.disks.0.thin_provisioned
  }
  network_interface {
    network_id = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.ubuntu_template.network_interface_types.0
  }
  wait_for_guest_net_timeout = 0

  clone {
    template_uuid = data.vsphere_virtual_machine.ubuntu_template.id
  }

  vapp {
    properties = {
      hostname    = "${var.project_prefix}-ubuntu"
      public-keys = var.ssh_public_key
      user-data   = base64encode(templatefile("${path.module}/templates/cloudinit.yaml", local.templatevars))
    }
  }

  lifecycle {
    ignore_changes = [
      annotation,
      vapp[0].properties,
      clone[0].template_uuid,
      clone[0].customize[0].dns_server_list,
      clone[0].customize[0].network_interface[0]
    ]
  }
}

output "vm" {
  value = vsphere_virtual_machine.ubuntu
}
