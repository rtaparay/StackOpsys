output "vm_ipv4_address_vms" {
  description = "Retrieves IPv4 address for a k8s cluster"
  value       = module.vms_proxmox.vm_ipv4_address_vms
}
output "config_ipv4_addresses" {
  description = "Retrieves VM names with IPv4 address for a k8s cluster"
  value       = module.vms_proxmox.config_ipv4_addresses
}
output "qemu_ipv4_addresses" {
  description = "Retrieves VM names with IPv4 address for a k8s cluster"
  value       = module.vms_proxmox.qemu_ipv4_addresses
}
output "cluster_name" {
  description = "Retrieves the name for a k8s cluster"
  value       = var.cluster.name
  sensitive   = false
}
