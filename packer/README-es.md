# 🛠️ Packer Proxmox

Este proyecto contiene una plantilla de [Packer](https://www.packer.io/) para crear imágenes personalizadas en **Proxmox VE**. Es ideal para automatizar la creación de imágenes base como Ubuntu Server con configuraciones específicas preinstaladas (como kubeadm, etc.).

## 🚀 Requisitos

- Proxmox VE con acceso API
- [Packer](https://developer.hashicorp.com/packer) ≥ 1.8
- Token de API con permisos para crear VMs

---

## 📦 Pasos para usar

### 1️⃣ Iniciar Packer (instalar plugins y preparar entorno)
```bash
packer init -upgrade .
```

### ✅ Validar la plantilla con variables personalizadas
```bash
packer validate -var-file=dev.pkrvars.hcl .
```

### 🏗️ Construir imagen (modo interactivo en caso de error)
```bash
packer build -on-error=ask -var-file="dev.pkrvars.hcl" .
```

### 🔍 Construcción detallada con logs
```bash
PACKER_LOG=1 packer build -on-error=ask -var-file="dev.pkrvars.hcl" . 2>&1 | tee logs/packer-build-$(date +"%Y-%m-%d_%H:%M:%S").log
```

---

## 📁 Estructura recomendada del proyecto

```
packer
├── base-images
│   ├── files
│   │   └── 99-pve.cfg               # archivo de configuración para PVE
│   ├── http
│   │   ├── meta-data                # archivo de metadatos para cloud-init
│   │   └── user-data                # archivo de datos de usuario para cloud-init
│   ├── logs
│   │   ├── packer-build-*.log       # logs de la construcción de la imagen
│   ├── dev.pkrvars.hcl              # variables para desarrollo
│   │   └── install-kubeadm.sh       # script para instalar kubeadm
│   ├── ubuntu-server-noble.pkr.hcl # plantilla de Packer para Ubuntu Server
│   └── variables.pkr.hcl            # variables comunes para todas las plantillas
└── README.md
```

---
La imagen base es Ubuntu Server 24.04 LTS, tiene habilitado firewalld por defecto.

Expliquemos en qué consiste cada uno:

| **Puerto o rango** | **Protocolo** | **Función** | **Dirección** | **Servicios que lo utilizan** |
| --- | --- | --- | --- | --- |
| 6443 | TCP | API de Kubernetes | Entrante | Todos |
| 2379-2380 | TCP | Servicios etcd | Entrante | kubi-apiserver, etcd |
| 10250 | TCP | Kubelet API | Entrante | Self, control plane |
| 10251 | TCP | kube-scheduler | Entrante | Self |
| 10252 | TCP | kube-controller-manager | Entrante | Self |

---