# 🚀 StackOpsys – IaC para Clústeres Kubernetes sobre Proxmox

**StackOpsys** es un stack de automatización de infraestructura que orquesta la creación de clústeres Kubernetes desde cero utilizando **Packer**, **Terraform** y **Ansible** sobre entornos **Proxmox**.

Esta solución implementa buenas prácticas de **Infraestructura como Código (IaC)** para que puedas reproducir, escalar y mantener tu infraestructura Kubernetes de manera confiable y eficiente.

---

## 🧰 Tecnologías Usadas

- ⚙️ **Packer** → Crea imágenes base con Kubeadm preinstalado
- 📦 **Terraform** → Provisiona máquinas virtuales en Proxmox VE
- 🔧 **Ansible** → Configura los nodos, instala paquetes y une workers al clúster
- ☁️ **Proxmox VE** → Entorno de virtualización local
- 🐳 **Kubernetes (kubeadm)** → Orquestación de contenedores

---

## 🌐 Arquitectura General

```
                 +---------------------------+
                 |        Packer             |
                 |  - Imagen base Ubuntu     |
                 |  - Script de instalación  |
                 +------------+--------------+
                              |
                              v
       +----------------------+----------------------+
       |                 Terraform                  |
       | - Crea VMs (master / workers) en Proxmox   |
       | - Usa la imagen generada por Packer        |
       +----------------------+----------------------+
                              |
                              v
                 +------------+--------------+
                 |          Ansible          |
                 |  - Instala paquetes       |
                 |  - Une workers al cluster |
                 +---------------------------+
```

---

## 📁 Estructura del Proyecto

```
stackopsys/
packer
├── base-images
│   ├── dev.example.pkrvars.hcl
│   ├── files
│   │   └── 99-pve.cfg
│   ├── http
│   │   ├── meta-data
│   │   └── user-data
│   ├── logs
│   │   └── packer-build-2025-08-18_00:25:18.log
│   ├── scripts
│   │   └── install-configure.sh
│   ├── ubuntu-server-noble.pkr.hcl
│   └── variables.pkr.hcl
└── README.md
```

---

## ⚙️ Requisitos Previos

- Proxmox VE configurado y accesible
- Token de API de Proxmox con permisos suficientes
- Packer instalado `>= 1.8`
- Terraform instalado `>= 1.4`
- Ansible instalado `>= 2.14`
- Acceso SSH a las VMs
- Conexión a internet para las VMs

---


## 💡 Características Clave

- Creación automatizada de clústeres Kubernetes v1.30+
- Compatible con Proxmox VE y cloud-init
- Modular, mantenible y reproducible
- Lista para producción y ambientes locales
- Fácilmente ampliable para monitoreo, backup o CI/CD

---

## 🤝 Contribuciones

¡Contribuciones son bienvenidas! Puedes abrir issues, enviar pull requests o sugerir mejoras.

---

## 📄 Licencia

MIT © Raul Tapara