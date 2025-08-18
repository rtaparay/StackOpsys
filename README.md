# 🚀 StackOpsys – IaC for Kubernetes Clusters on Proxmox

**StackOpsys** is an infrastructure automation stack that orchestrates the full creation of Kubernetes clusters from scratch using **Packer**, **Terraform**, and **Ansible** on **Proxmox** environments.

This solution applies best practices of **Infrastructure as Code (IaC)** to help you reliably reproduce, scale, and maintain your Kubernetes infrastructure.

---

## 🧰 Technologies Used

- ⚙️ **Packer** → Builds base images with preinstalled Kubeadm
- 📦 **Terraform** → Provisions virtual machines on Proxmox VE
- 🔧 **Ansible** → Installs required packages and joins worker nodes to the cluster
- ☁️ **Proxmox VE** → Local virtualization platform
- 🐳 **Kubernetes (kubeadm)** → Container orchestration

---

## 🌐 General Architecture

```
                 +---------------------------+
                 |         Packer            |
                 |  - Base Ubuntu image      |
                 |  - Install script         |
                 +------------+--------------+
                              |
                              v
       +----------------------+----------------------+
       |                 Terraform                  |
       | - Creates VMs (master / workers) in Proxmox|
       | - Uses the image built by Packer           |
       +----------------------+----------------------+
                              |
                              v
                 +------------+--------------+
                 |          Ansible          |
                 |  - Installs packages      |
                 |  - Joins workers to cluster|
                 +---------------------------+
```

---

## 📁 Project Structure

```
stackopsys/
├── packer/
│   ├── base-images/
│   │   └── ubuntu-24.04-kubeadm.pkr.hcl
│   ├── scripts/
│   │   └── install-configure.sh
│   └── variables/
│       └── variables.json
│
│
└── README.md
```

---

## ⚙️ Prerequisites

- A configured and reachable Proxmox VE instance
- API token from Proxmox with sufficient permissions
- Packer installed `>= 1.8`
- Terraform installed `>= 1.4`
- Ansible installed `>= 2.14`
- SSH access to the VMs
- Internet access from the VMs

---

## 💡 Key Features

- Automated creation of Kubernetes clusters (v1.30+)
- Compatible with Proxmox VE and cloud-init
- Modular, maintainable, and reproducible
- Production-ready for local or hybrid setups
- Easily extensible with monitoring, backup, or CI/CD

---

## 🤝 Contributions

Contributions are welcome! Feel free to open issues, submit pull requests, or suggest improvements.

---

## 📄 License

MIT © Raul Tapara