# Creating Admin Role and User in Proxmox for Terraform

This guide explains how to create an administrative role and user in Proxmox VE using the `pveum` command line tool, specifically for use with Terraform.

### 1. Add Proxmox Cluster User

ClusterCreator requires access to the Proxmox cluster. Execute the following commands on your Proxmox server to create a datacenter user:

#### 1. Add a Proxmox User:

```shell
pveum user add terraform@pve -comment "Terraform User"
```

#### 2. Add a Custom Role for Tofu with Required Permissions:

```shell
pveum role add TerraformRole -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Console Sys.Modify SDN.Use VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt User.Modify Mapping.Use"
```

#### 3. Assign the Role to the User at the Datacenter Level:

```shell
pveum acl modify / -user terraform@pve -role TerraformRole
```

#### 4. Create an API Token for the User:

```shell
pveum user token add terraform@pve provider --privsep=0
```

For additional documenation see [Proxmox API Token Authentication](https://registry.terraform.io/providers/bpg/proxmox/latest/docs#api-token-authentication).