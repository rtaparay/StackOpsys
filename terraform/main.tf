#########################
# Proxmox VMs
#########################
module "vms_proxmox" {
  source = "./modules/vms_proxmox"

  proxmox = var.proxmox

  cluster = {
    name                  = var.cluster.name
    gateway               = var.cluster.gateway
    dns_domain            = var.cluster.dns_domain
    dns_servers           = var.cluster.dns_servers
    cidr                  = var.cluster.cidr
    vlan_id               = var.cluster.vlan_id
    network_dhcp          = var.cluster.network_dhcp
    network_device_bridge = var.cluster.network_device_bridge
  }

  vms = var.vms
  pci = var.pci
}
#########################
# Tools Kubernetes
#########################
# module "tools_k8s" {
#   depends_on = [
#     module.talos_k8s
#   ]
#   source     = "./modules/tools_k8s"
#   providers = {
#     kubernetes = kubernetes
#     helm = helm
#   }
#   # longhorn
#   longhorn_enabled = var.longhorn_enabled
#   longhorn_version = var.longhorn_version
#   # ingress-nginx
#   ingress_nginx_enabled = var.ingress_nginx_enabled
# }
#########################