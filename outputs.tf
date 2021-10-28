output "ip" {
value = vsphere_virtual_machine.avi_controllers[*].default_ip_address
}