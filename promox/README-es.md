# Creación de un rol y usuario de administrador en Proxmox para Terraform

Esta guía explica cómo crear un rol y un usuario de administrador en Proxmox VE mediante la herramienta de línea de comandos `pveum`, específicamente para Terraform.

### 1. Agregar usuario al clúster de Proxmox

ClusterCreator requiere acceso al clúster de Proxmox. Ejecute los siguientes comandos en su servidor Proxmox para crear un usuario de centro de datos:

#### 1. Agregue un usuario de Proxmox:

```shell
pveum user add terraform@pam -comment "Terraform User"
```

#### 2. Agregue un rol personalizado para Terraform con los permisos requeridos:

```shell
pveum role add TerraformRole -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify Mapping.Use"
```

#### 3. Asignar el rol al usuario a nivel de centro de datos:

```shell
pveum acl modify / -user terraform@pam -role TerraformRole
```

#### 4. Crear un token de API para el usuario:

```shell
pveum user token add terraform@pam provider --privsep=0
```

Para obtener documentación adicional, consulte [Autenticación con token de API de Proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest/docs#api-token-authentication).