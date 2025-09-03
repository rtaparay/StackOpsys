# Kubernetes Cluster Automation with Ansible

## 📋 Project Description

This project automates the installation and configuration of a Kubernetes cluster using Ansible. The project is designed to deploy a Kubernetes cluster with kubeadm in a Proxmox environment, automatically configuring both master and worker nodes.

## 🏗️ Cluster Architecture

- **Master Node**: 1 node (192.168.100.220)
- **Worker Nodes**: 2 nodes (192.168.100.223, 192.168.100.224)
- **Runtime**: Containerd
- **Network**: Configuration with network modules for Istio/Kubeflow

## 📁 Project Structure

```
ansible/
├── ansible.cfg              # Ansible configuration
├── site.yaml               # Main playbook
├── Taskfile.yml            # Automated tasks with Task
├── inventory/
│   ├── hosts.ini           # Host inventory
│   └── group_vars/
│       └── all.yaml        # Global variables
├── roles/
│   ├── prepare-nodes/      # Node preparation
│   ├── configure-master-node/  # Master configuration
│   ├── configure-worker-node/  # Worker configuration
│   ├── kubeconfig/         # Kubeconfig configuration
│   └── reset-vm/           # Cluster reset (optional)
├── collections/
│   └── requirements.yaml   # Required Ansible collections
└── output/                 # Logs and output files
```

## 🔧 Prerequisites

### System Requirements
- Ansible 2.9+
- Python 3.x
- Task (go-task) for automation
- SSH access to target nodes

### Task Installation
```bash
# MacOS
brew install go-task/tap/go-task

# Ubuntu/Debian
sudo apt install task
```

### Ansible Collections Installation
```bash
ansible-galaxy collection install -r collections/requirements.yaml
```

## ⚙️ Configuration

### 1. Inventory
Edit `inventory/hosts.ini` with your node IPs:

```ini
[k8s_master]
cluster-kubeadm-k8s-master-01 ansible_host=192.168.100.220

[k8s_worker]
cluster-kubeadm-k8s-worker-01 ansible_host=192.168.100.223
cluster-kubeadm-k8s-worker-02 ansible_host=192.168.100.224
```

### 2. Variables
Adjust variables in `inventory/group_vars/all.yaml`:

```yaml
os: "linux"
arch: "amd64"
ansible_user: rtaparay
ansible_ssh_private_key_file: ~/.ssh/ansible
```

### 3. SSH Keys
Ensure passwordless SSH access is configured:
```bash
ssh-copy-id -i ~/.ssh/ansible.pub rtaparay@192.168.100.220
ssh-copy-id -i ~/.ssh/ansible.pub rtaparay@192.168.100.223
ssh-copy-id -i ~/.ssh/ansible.pub rtaparay@192.168.100.224
```

## 🚀 Execution

### Method 1: Using Task (Recommended)

#### Testing (Dry Run)
```bash
# Test complete configuration
task test:all

# Test master only
task test:site:master

# Test workers only
task test:site:worker
```

#### Full Deployment
```bash
# Execute complete configuration
task apply:all

# Main playbook only
task apply:site

# Kubeconfig configuration only
task apply:kubeconfig
```

### Method 2: Direct Ansible

#### Connectivity Verification
```bash
ansible all -i inventory/hosts.ini -m ping
```

#### Playbook Execution
```bash
# Full deployment
ansible-playbook site.yaml -i inventory/hosts.ini

# Master nodes only
ansible-playbook site.yaml -i inventory/hosts.ini --limit k8s_master

# Worker nodes only
ansible-playbook site.yaml -i inventory/hosts.ini --limit k8s_worker

# Check mode (dry run)
ansible-playbook site.yaml -i inventory/hosts.ini --check
```

## 📝 Roles and Functionality

### 1. prepare-nodes
- Disables swap
- Configures kernel modules (overlay, br_netfilter)
- Installs and configures containerd
- Configures modules for Istio/Kubeflow
- Installs kubeadm, kubelet and kubectl

### 2. configure-master-node
- Initializes cluster with kubeadm
- Configures cluster network
- Generates join token for workers

### 3. configure-worker-node
- Joins worker nodes to cluster
- Configures kubelet on workers

### 4. kubeconfig
- Copies kubeconfig from master
- Configures cluster access

### 5. reset-vm (Optional)
- Completely resets the cluster
- Cleans Kubernetes configurations

## 📊 Logs and Monitoring

Logs are stored in the `output/` directory:
- `ansible-YYYY-MM-DD_HH-MM-SS.log`: Execution logs
- `kubeconfig`: Kubernetes configuration file

## 🔍 Cluster Verification

After deployment, verify cluster status:

```bash
# Copy kubeconfig
scp rtaparay@192.168.100.220:~/.kube/config ~/.kube/config

# Verify nodes
kubectl get nodes

# Verify system pods
kubectl get pods -A

# Verify cluster status
kubectl cluster-info
```

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

3. **Cluster reset**
   ```bash
   # Uncomment reset-vm role in site.yaml
   ansible-playbook site.yaml -i inventory/hosts.ini --tags reset
   ```

### Detailed Logs
```bash
# Execute with maximum verbosity
ansible-playbook site.yaml -i inventory/hosts.ini -vvv
```

## 📚 References

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Kubeadm Installation Guide](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
- [Containerd Documentation](https://containerd.io/docs/)

## 🤝 Contributing

To contribute to the project:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License. See the LICENSE file for more details.