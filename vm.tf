provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_pass
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_template
  datacenter_id = data.vsphere_datacenter.dc.id
}




resource "vsphere_virtual_machine" "avi_controllers" {
  count            = var.avi_controller_cluster ? 3 : 1
  name             = "avi-lsc-${count.index + 1}"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder = var.vcenter_folder
  num_cpus = var.cpu
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = var.disk
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_pass
    host     = self.default_ip_address
  }


  # provisioner "remote-exec" {
  #   inline = ["sudo yum install sshpass -y"]

  #   connection {
  #     host        = self.default_ip_address
  #     type        = "ssh"
  #     user        = "root"
  #     password    = var.root_pass
  #   }
  # }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook avi-install.yml -u root -i '${self.default_ip_address},' -e ansible_user=root -e 'ansible_ssh_pass=${var.root_pass}' -e 'avi_controller_cpu=${var.avi_controller_cpu}' -e 'avi_controller_memory=${var.avi_controller_memory}' -e 'avi_controller_disk=${var.avi_controller_disk}' -e 'avi_controller_ip=${self.default_ip_address}' -e 'location_avi_tar=${var.location_avi_tar}'> ansible-playbook.log 2> ansible-error.log"
  }

 }
