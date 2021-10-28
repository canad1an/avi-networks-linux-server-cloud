#Vcenter
variable "vsphere_server" {
  description = "The fqdn of the vCenter server"
  type        = string
  default     = "vcenter.home.lab"
}
variable "vsphere_user" {
  description = "The vCenter login username"
  type        = string
  default     = "administrator@vsphere.local"
}
variable "vsphere_pass" {
  description = "The vCenter login password"
  type        = string
  default     = "password"
}
variable "vsphere_datacenter" {
  description = "The vCenter datacenter for the vms"
  type        = string
  default     = "vSAN Datacenter"
}
variable "vsphere_datastore" {
  description = "The vCenter datastore for the vms"
  type        = string
  default     = "vsanDatastore"
}
variable "vsphere_cluster" {
  description = "The vCenter cluster used to deploy the vms"
  type        = string
  default     = "vSAN Cluster"
}
variable "vsphere_network" {
  description = "The networks to be used on the vm"
  type        = string
  default     = "VM Network"
}
variable "vsphere_template" {
  description = "The vcenter template to clone"
  type        = string
  default     = "centos-79"
}
variable "vcenter_folder" {
  description = "The vcenter folder for the vms"
  type        = string
  default     = "VMs"
}

#VM Details
variable "disk" {
  description = "The disk size for the vms"
  type        = number
  default     = 128
}
variable "memory" {
  description = "The memory size for the vms"
  type        = number
  default     = 24000
}
variable "cpu" {
  description = "The vCPUs for the vms"
  type        = number
  default     = 8
}
variable "root_pass" {
  description = "The vCPUs for the vms"
  type        = string
  default     = "password"
}

#Controller Cluster Details
variable "avi_controller_cluster" {
  description = "Create a 3 controller cluster"
  type        = bool
  default     = false
}
variable "avi_controller_cpu" {
  description = "Avi controller allocated CPU"
  type        = number
  default     = 4
}
variable "avi_controller_memory" {
  description = "Avi controller allocated Memory in GB"
  type        = number
  default     = 12
}
variable "avi_controller_disk" {
  description = "Avi controller allocated Disk space in GB"
  type        = number
  default     = 20
}
