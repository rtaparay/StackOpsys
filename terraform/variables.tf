variable "proxmox" {
  description = "Proxmox configuration"
  type = object({
    endpoint           = optional(string)
    insecure           = optional(bool)
    username           = optional(string)
    password           = optional(string)
    api_token          = optional(string)
    ssh_agent          = optional(string, false)
    random_vm_ids      = optional(string, false)
    random_vm_id_start = optional(number, 1000)
    random_vm_id_end   = optional(number, 2000)
  })
  sensitive = true
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name                  = string
    network_dhcp          = optional(bool, false)
    gateway               = optional(string)
    dns_domain            = optional(string)
    dns_servers           = optional(list(string))
    cidr                  = optional(number)
    vlan_id               = optional(number, null)
    network_device_bridge = optional(string, "vmbr0")
    endpoint              = optional(string)
  })
}

variable "vms" {
  description = "VMs configuration"
  type = map(object({
    host_node        = string
    machine_type     = string
    datastore_id     = optional(string, "directory")
    ip               = optional(string)
    cpu              = number
    ram_dedicated    = number
    os_disk_size     = optional(number, 10)
    data_disk_size   = optional(number, 20)
    install_disk     = optional(string, "/dev/sda")
    disk_file_format = optional(string, "raw")
    gpu              = optional(string)
    file_id          = optional(string)
  }))
}

variable "pci" {
  description = "Mapping PCI configuration"
  type = map(object({
    name         = string
    id           = string
    iommu_group  = number
    node         = string
    path         = string
    subsystem_id = string
  }))
  default = null
}

# tools
variable "longhorn_enabled" {
  type    = bool
  default = false
}
variable "longhorn_version" {
  type    = string
  default = "v1.6.2"
}

variable "ingress_nginx_enabled" {
  type    = bool
  default = false
}