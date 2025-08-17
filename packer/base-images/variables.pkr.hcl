# Variable Definitions
variable "proxmox_api_url" {}
variable "proxmox_api_token_id" {}
variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}
variable "proxmox_node" {}

variable "vm_id" {}
variable "vm_name" {}
variable "template_description" {}

variable "iso_file" {}
variable "iso_storage_pool" {}

variable "disk_size" {}
variable "storage_pool" {}

variable "cores" {}
variable "memory" {}

variable "network_bridge" {}

variable "ssh_username" {}
variable "ssh_private_key_file" {}
variable "ssh_password" {
    type = string
    sensitive = true
}