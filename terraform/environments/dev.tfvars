proxmox = {
  endpoint           = "https://<IP_SERVER>:8006/api2/json"
  insecure           = true
  username           = "root"
  password           = ""
  api_token          = "root@pam!iac-tf=<token>"
  random_vm_ids      = true
  random_vm_id_start = 300
  random_vm_id_end   = 304
}

cluster = {
  name     = "cluster-kubeadm"
  gateway  = "192.168.100.1"
  cidr     = 24
  endpoint = "192.168.100.220"
}

vms = {
  "k8s-master-01" = {
    host_node      = "pve01"
    machine_type   = "controlplane"
    ip             = "192.168.100.220"
    cpu            = 4
    ram_dedicated  = 4096
    os_disk_size   = 70
    data_disk_size = 70
    datastore_id   = "directory"
    file_id        = "directory:9001/base-9001-disk-0.qcow2" # template from packer
  }
  # "k8s-master-02" = {
  #   host_node      = "pve01"
  #   machine_type   = "controlplane"
  #   ip             = "192.168.100.221"
  #   cpu            = 2
  #   ram_dedicated  = 4096
  #   os_disk_size   = 70
  #   data_disk_size = 70
  #   datastore_id   = "directory"
  # }
  "k8s-worker-01" = {
    host_node      = "pve01"
    machine_type   = "worker"
    ip             = "192.168.100.223"
    cpu            = 4
    ram_dedicated  = 8096
    os_disk_size   = 70
    data_disk_size = 70
    datastore_id   = "directory"
    file_id        = "directory:9001/base-9001-disk-0.qcow2" # template from packer
  }
  "k8s-worker-02" = {
    host_node      = "pve01"
    machine_type   = "worker"
    ip             = "192.168.100.224"
    cpu            = 4
    ram_dedicated  = 8096
    os_disk_size   = 70
    data_disk_size = 70
    datastore_id   = "directory"
    file_id        = "directory:9001/base-9001-disk-0.qcow2" # template from packer
  }
}

# # tools
# longhorn_enabled = false
# longhorn_version = "v1.9.0"

# # ngnix
# ingress_nginx_enabled = true