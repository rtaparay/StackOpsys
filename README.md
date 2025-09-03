# 🚀 StackOpsys – IaC for Kubernetes Clusters on Proxmox

**StackOpsys** is an infrastructure automation stack that orchestrates the complete creation of Kubernetes clusters from scratch using **Packer**, **Terraform**, and **Ansible** in **Proxmox** environments.

This solution applies **Infrastructure as Code (IaC)** best practices to help you reproduce, scale, and maintain your Kubernetes infrastructure reliably.

---

## 🧰 Technologies Used

- ⚙️ **Packer** → Builds base images with Kubeadm pre-installed
- 📦 **Terraform** → Provisions virtual machines on Proxmox VE
- 🔧 **Ansible** → Installs required packages and joins worker nodes to the cluster
- ☁️ **Proxmox VE** → Local virtualization platform
- 🐳 **Kubernetes (kubeadm)** → Container orchestration

---

## 🌐 General Architecture

<img src="https://github.com/rtaparay/StackOpsys/blob/main/img/flujo.png?raw=true"/>

---

## 📁 Project Structure

```
stackopsys/
├── packer/                     # Base image construction
│   ├── base-images/
│   │   ├── dev.example.pkrvars.hcl
│   │   ├── files/
│   │   ├── http/               # Cloud-init configuration
│   │   ├── scripts/            # Installation scripts
│   │   └── ubuntu-server-noble.pkr.hcl
│   └── README.md              # 📖 Detailed Packer guide
├── terraform/                  # Infrastructure provisioning
│   ├── environments/          # Environment configurations
│   ├── modules/
│   │   ├── vms_proxmox/      # Main VM module
│   │   └── tools_k8s/        # Kubernetes tools
│   ├── main.tf
│   └── README.md             # 📖 Detailed Terraform guide
├── ansible/                   # Configuration and deployment
│   ├── inventory/            # Host inventory
│   ├── roles/               # Configuration roles
│   │   ├── prepare-nodes/
│   │   ├── configure-master-node/
│   │   ├── configure-worker-node/
│   │   └── kubeconfig/
│   ├── site.yaml            # Main playbook
│   └── Readme.md            # 📖 Detailed Ansible guide
├── proxmox/                   # Proxmox configuration
│   └── README.md            # 📖 User and permissions configuration
└── README-es.md             # This file
```

---

## ⚙️ Prerequisites

### Required Software
- A configured and accessible Proxmox VE instance
- Proxmox API token with sufficient permissions
- Packer installed `>= 1.8`
- Terraform installed `>= 1.4`
- Ansible installed `>= 2.14`
- SSH access to VMs
- Internet access from VMs

### Network Configuration
- Gateway: `192.168.100.1`
- IP Range: `192.168.100.220-224`
- CIDR: `/24`
- DNS: Configure according to your environment

---

## 🚀 Complete Execution Guide

### Step 1: Proxmox Configuration
**📖 See detailed guide:** [`promox/README.md`](./promox/README.md)

```bash
# Create user and role for Terraform
pveum user add terraform@pam -comment "Terraform User"
pveum role add TerraformRole -privs "Datastore.Allocate..."
pveum acl modify / -user terraform@pam -role TerraformRole
pveum user token add terraform@pam provider --privsep=0
```

### Step 2: Base Image Construction with Packer
**📖 See detailed guide:** [`packer/README.md`](./packer/README.md)

```bash
cd packer/base-images

# Initialize Packer
packer init -upgrade .

# Validate configuration
packer validate -var-file=dev.pkrvars.hcl .

# Build image
PACKER_LOG=1 packer build -on-error=ask -var-file="dev.pkrvars.hcl" .
```

**Result:** Ubuntu 24.04 LTS base image with kubeadm, containerd, and necessary configurations.

### Step 3: VM Provisioning with Terraform
**📖 See detailed guide:** [`terraform/README.md`](./terraform/README.md)

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file=environments/dev.tfvars

# Apply configuration
terraform apply -var-file=environments/dev.tfvars
```

**Result:** 
- 1 master node (192.168.100.220)
- 2 worker nodes (192.168.100.223, 192.168.100.224)
- Network and storage configuration

### Step 4: Cluster Configuration with Ansible
**📖 See detailed guide:** [`ansible/Readme.md`](./ansible/Readme.md)

```bash
cd ansible

# Install required collections
ansible-galaxy collection install -r collections/requirements.yaml

# Verify connectivity
ansible all -i inventory/hosts.ini -m ping

# Deploy complete cluster
task apply:all
# Or alternatively:
ansible-playbook site.yaml -i inventory/hosts.ini
```

**Result:** Fully functional Kubernetes cluster with:
- Configured master node
- Worker nodes joined to the cluster
- Kubeconfig available for administration

### Step 5: Cluster Verification

```bash
# Copy kubeconfig
scp rtaparay@192.168.100.220:~/.kube/config ~/.kube/config

# Verify nodes
kubectl get nodes

# Verify system pods
kubectl get pods -A

# Cluster information
kubectl cluster-info
```

---

## 💡 Implemented Features

### 🔧 Cluster Components
- **Container Runtime:** Containerd
- **Kubernetes Version:** v1.30+
- **Initialization:** kubeadm
- **Network:** Configuration prepared for Istio/Kubeflow
- **Storage:** Longhorn (distributed)
- **Ingress:** NGINX Ingress Controller
- **Monitoring:** Ready for Prometheus/Grafana

### 🛡️ Security and Configuration
- Firewalld enabled by default
- Kubernetes ports configured automatically
- SSH access with keys
- Secure API tokens

### 🔄 Automation and CI/CD
- GitHub Actions integrated
- Task runner for simplified commands
- Detailed logs of all operations
- Separate environments (dev, qas, prd)

---

## 📊 Monitoring and Logs

### Log Locations
- **Packer:** `packer/base-images/logs/`
- **Terraform:** `terraform/output/`
- **Ansible:** `ansible/output/`

### Status Verification
```bash
# Node status
kubectl get nodes -o wide

# Cluster resources
kubectl top nodes
kubectl top pods -A

# Cluster events
kubectl get events --sort-by='.lastTimestamp'
```

---

## 🛠️ Troubleshooting

### Common Issues

1. **SSH connectivity error**
   ```bash
   ansible all -i inventory/hosts.ini -m ping
   ```

2. **Swap issues**
   ```bash
   sudo swapoff -a
   sudo sed -i '/ swap / s/^/#/' /etc/fstab
   ```

3. **Complete cluster reset**
   ```bash
   # Uncomment reset-vm role in site.yaml
   ansible-playbook site.yaml -i inventory/hosts.ini --tags reset
   ```

### Detailed Logs
```bash
# Ansible with maximum verbosity
ansible-playbook site.yaml -i inventory/hosts.ini -vvv

# Terraform with debug
TF_LOG=DEBUG terraform apply -var-file=environments/dev.tfvars

# Packer with logs
PACKER_LOG=1 packer build -var-file="dev.pkrvars.hcl" .
```

---

## 🔄 Lifecycle Management

### Cluster Update
```bash
# Update base image
cd packer/base-images && packer build -var-file="dev.pkrvars.hcl" .

# Update infrastructure
cd terraform && terraform apply -var-file=environments/dev.tfvars

# Reconfigure nodes
cd ansible && ansible-playbook site.yaml -i inventory/hosts.ini
```

### Cluster Scaling
```bash
# Add new workers in terraform/environments/dev.tfvars
# Apply changes
terraform apply -var-file=environments/dev.tfvars

# Configure new nodes
ansible-playbook site.yaml -i inventory/hosts.ini --limit k8s_worker
```

### Complete Destruction
```bash
# Destroy infrastructure
cd terraform && terraform destroy -var-file=environments/dev.tfvars
```

---

## 📚 Additional Documentation

- **Packer:** [`packer/README.md`](./packer/README.md) - Base image construction
- **Terraform:** [`terraform/README.md`](./terraform/README.md) - Infrastructure provisioning
- **Ansible:** [`ansible/Readme.md`](./ansible/Readme.md) - Configuration and deployment
- **Proxmox:** [`promox/README.md`](./promox/README.md) - Permissions configuration
- **Ansible Installation:** [`ansible/install_ansible.md`](./ansible/install_ansible.md)
- **Inventory Configuration:** [`ansible/inventory_ansible.md`](./ansible/inventory_ansible.md)

---

## 🔄 Detailed Workflow:

<img src="https://github.com/rtaparay/StackOpsys/blob/main/img/flujo.png?raw=true"/>

### 1. Pipeline Initiation 🚀
- DevOps Engineer pushes to Git repository
- CI/CD pipeline is automatically triggered

### 2. Image Construction 📦
- Packer builds optimized VM templates
- Installs base packages, Docker, K8s tools
- Creates template in Proxmox VE

### 3. Infrastructure Provisioning 🏗️
- Terraform reads configuration (terraform.tfvars)
- Creates VMs from Packer template
- Configures network, resources, and storage

### 4. Configuration and Deployment 🔧
- Ansible executes playbooks automatically
- Configures master and worker nodes
- Installs and configures Kubernetes

### 5. Final Result ☸️
- Functional Kubernetes cluster
- kubectl for management
- Monitoring and logs configured


## 🤝 Contributions

Contributions are welcome. Feel free to open issues, submit pull requests, or suggest improvements.

### Contribution Process
1. Fork the repository
2. Create feature branch
3. Make changes
4. Run tests
5. Submit pull request

---

## 📄 License

MIT © Raul Tapara