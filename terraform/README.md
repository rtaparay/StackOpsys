# Terraform Module for Kubernetes Cluster on Proxmox

A comprehensive Terraform module for creating and managing a Kubernetes cluster on Proxmox Virtual Environment using Ubuntu 22.04. This project includes complete automation with Packer, Terraform, and Ansible, plus GitHub Actions integration for CI/CD.

---

## 📋 Table of Contents

- Project Architecture
- Prerequisites
- Project Structure
- Configuration
- Installation and Usage
- Modules
- Environments
- Kubernetes Tools
- CI/CD with GitHub Actions
- Outputs
- Troubleshooting
## 🏗️ Project Architecture
This project implements a complete infrastructure for Kubernetes using:

- Packer : Creates base VM templates with Ubuntu 22.04
- Terraform : Provisions infrastructure on Proxmox
- Ansible : Post-deployment configuration
- Kubernetes : Cluster with master and worker nodes
- Additional Tools : Longhorn (storage), NGINX Ingress Controller
## 📋 Prerequisites
### Required Software
- Proxmox Virtual Environment 8.3.3+
- Terraform v1.8+
- Packer
- Ansible
- kubectl
### Proxmox Configuration
1. User and permissions : Create user with appropriate permissions for Terraform
2. API Token : Generate API token for authentication
3. Base template : Create template with Packer (reference: directory:9001/base-9001-disk-0.qcow2 )
4. Network : Configure network bridge ( vmbr0 by default)
5. Storage : Configure datastore ( directory by default)

### Network Configuration
- Gateway : 192.168.100.1
- IP Range : 192.168.100.220-224
- CIDR : /24
- DNS : Configure according to your environment
## 📁 Project Structure
```
├── .github/
│   └── workflows/
│       └── terraform.yaml          # CI/CD pipeline
├── environments/                   # Environment configurations
│   ├── dev.tfvars                  # Development
│   ├── prd.tfvars                  # Production
│   ├── qas.tfvars                  # QA/Testing
├── modules/
│   ├── vms_proxmox/                # Main VM module
│   │   ├── main.tf                 # Main resources
│   │   ├── variables.tf            # Module variables
│   │   ├── outputs.tf              # Module outputs
│   │   ├── providers.tf            # Providers
│   │   ├── local.tf                # Local configuration
│   │   └── mapping_pci.tf          # PCI mapping for GPU
│   └── tools_k8s/                  # Kubernetes tools
│       ├── longhorn.tf             # Distributed storage
│       ├── nginx.tf                # Ingress controller
│       ├── reloader.tf             # Config reloader
│       └── versions.tf             # Provider versions
├── output/                         # Generated files
│   └── kubeconfig.yaml            # kubectl configuration
├── main.tf                         # Main configuration
├── variables.tf                    # Global variables
├── outputs.tf                      # Main outputs
├── providers.tf                    # Provider configuration
├── versions.tf                     # Required versions
└── prepare-release-tfdocs.sh       # Documentation script
```
## ⚙️ Configuration
### 1. Proxmox Variables
Configure Proxmox credentials in your .tfvars file:

```
proxmox = {
  endpoint           = "https://192.168.100.100:8006/api2/json"
  insecure           = true
  username           = "root"
  password           = "your_password"
  api_token          = "root@pam!iac-tf=your_token_here"
  random_vm_ids      = true
  random_vm_id_start = 300
  random_vm_id_end   = 304
}
```
### 2. Cluster Configuration
```
cluster = {
  name     = "cluster-kubeadm"
  gateway  = "192.168.100.1"
  cidr     = 24
  endpoint = "192.168.100.220"
}
```
### 3. VM Configuration
```
vms = {
  "k8s-master-01" = {
    host_node      = "pve01"
    machine_type   = "controlplane"
    ip             = "192.168.100.220"
    cpu            = 4
    ram_dedicated  = 4096
    os_disk_size   = 70
    data_disk_size = 70
    datastore_id   = "directory"
    file_id        = "directory:9001/base-9001-disk-0.qcow2"
  }
  "k8s-worker-01" = {
    host_node      = "pve01"
    machine_type   = "worker"
    ip             = "192.168.100.223"
    cpu            = 4
    ram_dedicated  = 8096
    os_disk_size   = 70
    data_disk_size = 70
    datastore_id   = "directory"
    file_id        = "directory:9001/base-9001-disk-0.qcow2"
  }
  "k8s-worker-02" = {
    host_node      = "pve01"
    machine_type   = "worker"
    ip             = "192.168.100.224"
    cpu            = 4
    ram_dedicated  = 8096
    os_disk_size   = 70
    data_disk_size = 70
    datastore_id   = "directory"
    file_id        = "directory:9001/base-9001-disk-0.qcow2"
  }
}
```
## 🚀 Installation and Usage

### 1. Initialization

```sh
## Clone the repository
╰─ $ git clone https://github.com/rtaparay/StackOpsys
╰─ $ cd terraform
╰─ $ terraform init

### ouput                             
Initializing the backend...
Initializing modules...
- vms_proxmox in modules/vms_proxmox
Initializing provider plugins...
- Reusing previous version of hashicorp/time from the dependency lock file
- Reusing previous version of hashicorp/kubernetes from the dependency lock file
- Reusing previous version of hashicorp/helm from the dependency lock file
- Reusing previous version of hashicorp/local from the dependency lock file
- Reusing previous version of hashicorp/http from the dependency lock file
- Reusing previous version of bpg/proxmox from the dependency lock file
- Installing hashicorp/kubernetes v2.38.0...
- Installed hashicorp/kubernetes v2.38.0 (signed by HashiCorp)
- Installing hashicorp/helm v3.0.2...
- Installed hashicorp/helm v3.0.2 (signed by HashiCorp)
- Installing hashicorp/local v2.5.3...
- Installed hashicorp/local v2.5.3 (signed by HashiCorp)
- Installing hashicorp/http v3.5.0...
- Installed hashicorp/http v3.5.0 (signed by HashiCorp)
- Installing bpg/proxmox v0.81.0...
- Installed bpg/proxmox v0.81.0 (self-signed, key ID F0582AD6AE97C188)
- Installing hashicorp/time v0.13.1...
- Installed hashicorp/time v0.13.1 (signed by HashiCorp)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### 2. Planning
```
# Review changes to be applied
```sh
╰─ $ terraform plan -var-file=environments/dev.tfvars
### ouput
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-worker-01"]: Refreshing state... [id=303]
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-worker-02"]: Refreshing state... [id=301]
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-master-01"]: Refreshing state... [id=302]

Plan: 0 to add, 3 to change, 0 to destroy.
```

### 3. Application
```sh
# Apply the configuration

╰─ $ terraform apply -var-file=environments/dev.tfvars

### ouput
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-worker-02"]: Modifying... [id=301]
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-worker-01"]: Modifying... [id=303]
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-master-01"]: Modifying... [id=302]

Apply complete! Resources: 4 added, 3 changed, 0 destroyed.

Outputs:

cluster_name = "cluster-kubeadm"
config_ipv4_addresses = {
  "cluster-kubeadm-k8s-master-01" = "192.168.100.220/24"
  "cluster-kubeadm-k8s-worker-01" = "192.168.100.223/24"
  "cluster-kubeadm-k8s-worker-02" = "192.168.100.224/24"
}
qemu_ipv4_addresses = {
  "k8s-master-01" = "192.168.100.220"
  "k8s-worker-01" = "192.168.100.223"
  "k8s-worker-02" = "192.168.100.224"
}
vm_ipv4_address_vms = [
  "192.168.100.220/24",
  "192.168.100.223/24",
  "192.168.100.224/24",
]
```

### 5. Destruction
```sh
# Destroy all infrastructure

╰─ $ terraform destroy -var-file=environments/dev.tfvars

### ouput
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.vms_proxmox.time_sleep.waiting_if_dhcp: Destroying... [id=2025-08-20T04:37:29Z]
module.vms_proxmox.time_sleep.waiting_if_dhcp: Destruction complete after 0s
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-master-01"]: Destroying... [id=302]
module.vms_proxmox.proxmox_virtual_environment_vm.vms["k8s-worker-01"]: Destroying... [id=303]

Destroy complete! Resources: 4 destroyed.
```

## 📦 Modules
### vms_proxmox Module
Purpose : Create and manage virtual machines on Proxmox

Features :

- VM creation with custom configuration
- Support for multiple node types (controlplane, worker)
- Static network configuration
- Separate system and data disks
- PCI mapping support (GPU passthrough)
- Automatic tags for organization
Resources created :

- proxmox_virtual_environment_vm.vms : Main VMs
- time_sleep.waiting_if_dhcp : Wait for DHCP configuration
- proxmox_virtual_environment_hardware_mapping_pci.pci : Optional PCI mapping
### tools_k8s Module
Purpose : Install additional tools on the Kubernetes cluster

Tools included :
 Longhorn (Storage)
- Version : v1.9.0 (configurable)
- Namespace : longhorn-system
- Function : Distributed storage for Kubernetes
- Configuration : Data path at /var/mnt/longhorn NGINX Ingress Controller
- Version : 4.12.2
- Namespace : ingress-nginx
- Function : HTTP/HTTPS traffic ingress controller
- Configuration : DaemonSet with fixed IP (192.168.100.104) Reloader
- Function : Automatic pod restart when ConfigMaps/Secrets change
## 🌍 Environments
The project supports multiple environments via .tfvars files:

- dev.tfvars : Development environment (3 nodes)
- stg.tfvars : Staging environment
- qas.tfvars : QA/testing environment
- prd.tfvars : Production environment
Each environment can have:

- Different resource configurations (CPU, RAM, disk)
- Different networks and IP ranges
- Specific tool configurations
## 🛠️ Kubernetes Tools
### Enabling Tools
To enable tools, uncomment and configure in your .tfvars file:

```yaml
# Distributed storage
longhorn_enabled = true
longhorn_version = "v1.9.0"

# Ingress controller
ingress_nginx_enabled = true
```
### Accessing Longhorn UI
```
# Port forward to access UI
kubectl port-forward -n longhorn-system svc/longhorn-frontend 8080:80
# Access http://localhost:8080
```
### Ingress Configuration
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: example-service
            port:
              number: 80
```
## 🔄 CI/CD with GitHub Actions
The project includes a complete CI/CD pipeline:

### Secret Configuration
In your GitHub repository, configure these secrets:

```yaml
PROXMOX_VE_SSH_USERNAME=root
PROXMOX_VE_SSH_PASSWORD=your_password
PROXMOX_VE_API_TOKEN=your_api_token
TF_VAR_GITHUB_PAT=your_github_token
```
### Environment Variables
```yaml
PROXMOX_VE_ENDPOINT=https://your-proxmox:8006/api2/json
PROXMOX_VE_INSECURE=true
```
### Pipeline Steps
1. Checkout : Download code
2. Setup Terraform : Install Terraform
3. Init : Initialize project
4. Format Check : Verify code format
5. Validate : Validate configuration
6. Plan : Generate execution plan
7. Apply : Apply changes (main branch only)

## 📤 Outputs
The project generates several useful outputs:

```
# List of all VM IPs
vm_ipv4_address_vms = [
  "192.168.100.220/24",
  "192.168.100.223/24",
  "192.168.100.224/24"
]

# VM name to IP mapping
config_ipv4_addresses = {
  "cluster-kubeadm-k8s-master-01" = "192.168.100.220/24"
  "cluster-kubeadm-k8s-worker-01" = "192.168.100.223/24"
  "cluster-kubeadm-k8s-worker-02" = "192.168.100.224/24"
}

# QEMU IPs (without cluster prefix)
qemu_ipv4_addresses = {
  "k8s-master-01" = "192.168.100.220"
  "k8s-worker-01" = "192.168.100.223"
  "k8s-worker-02" = "192.168.100.224"
}

# Cluster name
cluster_name = "cluster-kubeadm"
```
## 🔧 Troubleshooting
### Common Issues 1. Proxmox Authentication Error
```
# Verify connectivity
curl -k https://192.168.100.100:8006/api2/json/version

# Verify token
curl -k -H "Authorization: PVEAPIToken=root@pam!iac-tf=your_token" \
  https://192.168.100.100:8006/api2/json/version
``` 2. Template Not Found
```

# List available templates
```
pvesh get /nodes/pve01/storage/directory/content --content vztmpl
```
# Verify template exists
```
pvesh get /nodes/pve01/qemu/9001/config
```
# Network Issues
```
# Verify bridge configuration
ip link show vmbr0
```
# Verify node status
```
kubectl get nodes -o wide
```
# Check kubelet logs
```
ssh user@192.168.100.220 "sudo journalctl -u kubelet -f"
```
### Useful Commands
```
# View Terraform state
terraform show

# View outputs
terraform output

# Refresh state
terraform refresh -var-file=environments/dev.tfvars
```

### Logging and Debugging
```
# Enable detailed Terraform logs
export TF_LOG=DEBUG
terraform apply -var-file=environments/dev.tfvars

# Verify kubeconfig configuration
kubectl config view --kubeconfig=output/kubeconfig.yaml
```
## 📚 Additional Resources
- Proxmox Documentation
- Terraform Proxmox Provider
- Kubernetes Documentation
- Longhorn Documentation
- NGINX Ingress Controller

## 🤝 Contributing
1. Fork the project
2. Create a feature branch ( git checkout -b feature/new-functionality )
3. Commit your changes ( git commit -am 'Add new functionality' )
4. Push to the branch ( git push origin feature/new-functionality )
5. Create a Pull Request

## 📄 License
This project is licensed under the MIT License. See the LICENSE file for details.