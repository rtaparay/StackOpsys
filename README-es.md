# 🚀 StackOpsys – IaC para Clusters de Kubernetes en Proxmox

**StackOpsys** es un stack de automatización de infraestructura que orquesta la creación completa de clusters de Kubernetes desde cero utilizando **Packer**, **Terraform** y **Ansible** en entornos **Proxmox**.

Esta solución aplica las mejores prácticas de **Infrastructure as Code (IaC)** para ayudarte a reproducir, escalar y mantener tu infraestructura de Kubernetes de manera confiable.

---

## 🧰 Tecnologías Utilizadas

- ⚙️ **Packer** → Construye imágenes base con Kubeadm preinstalado
- 📦 **Terraform** → Provisiona máquinas virtuales en Proxmox VE
- 🔧 **Ansible** → Instala paquetes requeridos y une nodos worker al cluster
- ☁️ **Proxmox VE** → Plataforma de virtualización local
- 🐳 **Kubernetes (kubeadm)** → Orquestación de contenedores

---

## 🌐 Arquitectura General

```
                 +---------------------------+
                 |         Packer            |
                 |  - Imagen base Ubuntu     |
                 |  - Script de instalación  |
                 +------------+--------------+
                              |
                              v
       +----------------------+----------------------+
       |                 Terraform                  |
       | - Crea VMs (master/workers) en Proxmox    |
       | - Usa la imagen construida por Packer     |
       +----------------------+----------------------+
                              |
                              v
                 +------------+--------------+
                 |          Ansible          |
                 |  - Instala paquetes      |
                 |  - Une workers al cluster|
                 +---------------------------+
```

---

## 📁 Estructura del Proyecto

```
stackopsys/
├── packer/                     # Construcción de imágenes base
│   ├── base-images/
│   │   ├── dev.example.pkrvars.hcl
│   │   ├── files/
│   │   ├── http/               # Configuración cloud-init
│   │   ├── scripts/            # Scripts de instalación
│   │   └── ubuntu-server-noble.pkr.hcl
│   └── README.md              # 📖 Guía detallada de Packer
├── terraform/                  # Provisión de infraestructura
│   ├── environments/          # Configuraciones por ambiente
│   ├── modules/
│   │   ├── vms_proxmox/      # Módulo principal de VMs
│   │   └── tools_k8s/        # Herramientas de Kubernetes
│   ├── main.tf
│   └── README.md             # 📖 Guía detallada de Terraform
├── ansible/                   # Configuración y despliegue
│   ├── inventory/            # Inventario de hosts
│   ├── roles/               # Roles de configuración
│   │   ├── prepare-nodes/
│   │   ├── configure-master-node/
│   │   ├── configure-worker-node/
│   │   └── kubeconfig/
│   ├── site.yaml            # Playbook principal
│   └── Readme.md            # 📖 Guía detallada de Ansible
├── proxmox/                   # Configuración de Proxmox
│   └── README.md            # 📖 Configuración de usuarios y permisos
└── README-es.md             # Este archivo
```

---

## ⚙️ Prerrequisitos

### Software Requerido
- Una instancia de Proxmox VE configurada y accesible
- Token de API de Proxmox con permisos suficientes
- Packer instalado `>= 1.8`
- Terraform instalado `>= 1.4`
- Ansible instalado `>= 2.14`
- Acceso SSH a las VMs
- Acceso a Internet desde las VMs

### Configuración de Red
- Gateway: `192.168.100.1`
- Rango de IPs: `192.168.100.220-224`
- CIDR: `/24`
- DNS: Configurar según tu entorno

---

## 🚀 Guía de Ejecución Completa

### Paso 1: Configuración de Proxmox
**📖 Ver guía detallada:** [`promox/README.md`](./promox/README.md)

```bash
# Crear usuario y rol para Terraform
pveum user add terraform@pam -comment "Terraform User"
pveum role add TerraformRole -privs "Datastore.Allocate..."
pveum acl modify / -user terraform@pam -role TerraformRole
pveum user token add terraform@pam provider --privsep=0
```

### Paso 2: Construcción de Imagen Base con Packer
**📖 Ver guía detallada:** [`packer/README.md`](./packer/README.md)

```bash
cd packer/base-images

# Inicializar Packer
packer init -upgrade .

# Validar configuración
packer validate -var-file=dev.pkrvars.hcl .

# Construir imagen
PACKER_LOG=1 packer build -on-error=ask -var-file="dev.pkrvars.hcl" .
```

**Resultado:** Imagen base Ubuntu 24.04 LTS con kubeadm, containerd y configuraciones necesarias.

### Paso 3: Provisión de VMs con Terraform
**📖 Ver guía detallada:** [`terraform/README.md`](./terraform/README.md)

```bash
cd terraform

# Inicializar Terraform
terraform init

# Planificar despliegue
terraform plan -var-file=environments/dev.tfvars

# Aplicar configuración
terraform apply -var-file=environments/dev.tfvars
```

**Resultado:** 
- 1 nodo master (192.168.100.220)
- 2 nodos worker (192.168.100.223, 192.168.100.224)
- Configuración de red y almacenamiento

### Paso 4: Configuración del Cluster con Ansible
**📖 Ver guía detallada:** [`ansible/Readme.md`](./ansible/Readme.md)

```bash
cd ansible

# Instalar colecciones requeridas
ansible-galaxy collection install -r collections/requirements.yaml

# Verificar conectividad
ansible all -i inventory/hosts.ini -m ping

# Desplegar cluster completo
task apply:all
# O alternativamente:
ansible-playbook site.yaml -i inventory/hosts.ini
```

**Resultado:** Cluster de Kubernetes completamente funcional con:
- Master node configurado
- Worker nodes unidos al cluster
- Kubeconfig disponible para administración

### Paso 5: Verificación del Cluster

```bash
# Copiar kubeconfig
scp rtaparay@192.168.100.220:~/.kube/config ~/.kube/config

# Verificar nodos
kubectl get nodes

# Verificar pods del sistema
kubectl get pods -A

# Información del cluster
kubectl cluster-info
```

---

## 💡 Características Implementadas

### 🔧 Componentes del Cluster
- **Runtime de Contenedores:** Containerd
- **Versión de Kubernetes:** v1.30+
- **Inicialización:** kubeadm
- **Red:** Configuración preparada para Istio/Kubeflow
- **Almacenamiento:** Longhorn (distribuido)
- **Ingress:** NGINX Ingress Controller
- **Monitoreo:** Preparado para Prometheus/Grafana

### 🛡️ Seguridad y Configuración
- Firewalld habilitado por defecto
- Puertos de Kubernetes configurados automáticamente
- Acceso SSH con claves
- Tokens de API seguros

### 🔄 Automatización y CI/CD
- GitHub Actions integrado
- Task runner para comandos simplificados
- Logs detallados de todas las operaciones
- Ambientes separados (dev, qas, prd)

---

## 📊 Monitoreo y Logs

### Ubicaciones de Logs
- **Packer:** `packer/base-images/logs/`
- **Terraform:** `terraform/output/`
- **Ansible:** `ansible/output/`

### Verificación de Estado
```bash
# Estado de nodos
kubectl get nodes -o wide

# Recursos del cluster
kubectl top nodes
kubectl top pods -A

# Eventos del cluster
kubectl get events --sort-by='.lastTimestamp'
```

---

## 🛠️ Solución de Problemas

### Problemas Comunes

1. **Error de conectividad SSH**
   ```bash
   ansible all -i inventory/hosts.ini -m ping
   ```

2. **Problemas con swap**
   ```bash
   sudo swapoff -a
   sudo sed -i '/ swap / s/^/#/' /etc/fstab
   ```

3. **Reset completo del cluster**
   ```bash
   # Descomentar rol reset-vm en site.yaml
   ansible-playbook site.yaml -i inventory/hosts.ini --tags reset
   ```

### Logs Detallados
```bash
# Ansible con máxima verbosidad
ansible-playbook site.yaml -i inventory/hosts.ini -vvv

# Terraform con debug
TF_LOG=DEBUG terraform apply -var-file=environments/dev.tfvars

# Packer con logs
PACKER_LOG=1 packer build -var-file="dev.pkrvars.hcl" .
```

---

## 🔄 Gestión del Ciclo de Vida

### Actualización del Cluster
```bash
# Actualizar imagen base
cd packer/base-images && packer build -var-file="dev.pkrvars.hcl" .

# Actualizar infraestructura
cd terraform && terraform apply -var-file=environments/dev.tfvars

# Reconfigurar nodos
cd ansible && ansible-playbook site.yaml -i inventory/hosts.ini
```

### Escalado del Cluster
```bash
# Agregar nuevos workers en terraform/environments/dev.tfvars
# Aplicar cambios
terraform apply -var-file=environments/dev.tfvars

# Configurar nuevos nodos
ansible-playbook site.yaml -i inventory/hosts.ini --limit k8s_worker
```

### Destrucción Completa
```bash
# Destruir infraestructura
cd terraform && terraform destroy -var-file=environments/dev.tfvars
```

---

## 📚 Documentación Adicional

- **Packer:** [`packer/README.md`](./packer/README.md) - Construcción de imágenes base
- **Terraform:** [`terraform/README.md`](./terraform/README.md) - Provisión de infraestructura
- **Ansible:** [`ansible/Readme.md`](./ansible/Readme.md) - Configuración y despliegue
- **Proxmox:** [`promox/README.md`](./promox/README.md) - Configuración de permisos
- **Instalación de Ansible:** [`ansible/install_ansible.md`](./ansible/install_ansible.md)
- **Configuración de Inventario:** [`ansible/inventory_ansible.md`](./ansible/inventory_ansible.md)

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Siéntete libre de abrir issues, enviar pull requests o sugerir mejoras.

### Proceso de Contribución
1. Fork del repositorio
2. Crear rama de feature
3. Realizar cambios
4. Ejecutar pruebas
5. Enviar pull request

---

## 📄 Licencia

MIT © Raul Tapara