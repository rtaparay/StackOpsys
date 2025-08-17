# Credenciales de Proxmox
proxmox_api_url = "https://<IP_PROXMOX>:8006/api2/json"  # Your Proxmox IP Address
proxmox_api_token_id = "root@pam!iac-tf"  # API Token ID
proxmox_api_token_secret = "" # API Token

# Configuración del nodo y VM
proxmox_node = "pve01"
vm_id = "9001"
vm_name = "template-k8s-ubuntu-24-04"
template_description = "Template Kubeadm Ubuntu Server Noble-24-04 Image"

# Configuración de ISO
iso_file = "directory:iso/ubuntu-24.04.3-live-server-amd64.iso"
iso_storage_pool = "directory"

# Configuración de hardware
disk_size = "70G"
storage_pool = "directory"
cores = "4"
memory = "8048"

# Configuración de red
network_bridge = "vmbr0"

# Configuración SSH
ssh_username = ""
ssh_password = ""
ssh_private_key_file = "~/.ssh/ansible"