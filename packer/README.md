# 🛠️ Packer Proxmox

This project contains a [Packer](https://www.packer.io/) template to build custom images for **Proxmox VE**. It’s ideal for automating the creation of base images like Ubuntu Server with pre-installed configurations (such as kubeadm, etc.).

## 🚀 Requirements

- Proxmox VE with API access
- [Packer](https://developer.hashicorp.com/packer) ≥ 1.8
- API token with permission to create VMs

---

## 📦 Usage Steps

### 1️⃣ Initialize Packer (install plugins and prepare the environment)
```bash
packer init -upgrade .
```

### ✅ Validate the template with custom variables
```bash
packer validate -var-file=dev.pkrvars.hcl .
```

### 🏗️ Build image (interactive mode on error)
```bash
packer build -on-error=ask -var-file="dev.pkrvars.hcl" .
```

### 🔍 Build with detailed logs
```bash
PACKER_LOG=1 packer build -on-error=ask -var-file="dev.pkrvars.hcl" . 2>&1 | tee logs/packer-build-$(date +"%Y-%m-%d_%H:%M:%S").log
```

---

## 📁 Recommended Project Structure

```
packer
├── base-images
│   ├── files
│   │   └── 99-pve.cfg               # PVE configuration file
│   ├── http
│   │   ├── meta-data                # cloud-init metadata
│   │   └── user-data                # cloud-init user data
│   ├── logs
│   │   ├── packer-build-*.log       # build logs
│   ├── dev.pkrvars.hcl              # development variables
│   │   └── install-configure.sh     # script to install kubeadm
│   ├── ubuntu-server-noble.pkr.hcl # Packer template for Ubuntu Server
│   └── variables.pkr.hcl            # common variables for all templates
└── README.md
```

---

The base image is Ubuntu Server 24.04 LTS and has **firewalld** enabled by default.

Below is a summary of the open ports:

| **Port or Range** | **Protocol** | **Function**              | **Direction** | **Used by**                   |
|------------------|--------------|---------------------------|---------------|-------------------------------|
| 6443             | TCP          | Kubernetes API            | Inbound       | All                           |
| 2379-2380        | TCP          | etcd services             | Inbound       | kube-apiserver, etcd          |
| 10250            | TCP          | Kubelet API               | Inbound       | Self, control plane           |
| 10251            | TCP          | kube-scheduler            | Inbound       | Self                          |
| 10252            | TCP          | kube-controller-manager   | Inbound       | Self                          |

---