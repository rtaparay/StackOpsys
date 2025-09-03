# Complete Ansible Inventory Guide

This guide provides detailed instructions for configuring and managing Ansible inventories, including SSH configuration, file structure, and best practices.

## Table of Contents
- [SSH Configuration](#ssh-configuration)
- [Inventory Structure](#inventory-structure)
- [Inventory Examples](#inventory-examples)
- [Verification Commands](#verification-commands)
- [Host Management](#host-management)
- [Advanced Configurations](#advanced-configurations)
- [Troubleshooting](#troubleshooting)

## SSH Configuration

### 1. Create SSH Key for Ansible

```bash
# Create specific SSH key for Ansible (recommended: ed25519)
ssh-keygen -t ed25519 -C "ansible" -f ~/.ssh/ansible

# Alternative with RSA (if ed25519 is not compatible)
ssh-keygen -t rsa -b 4096 -C "ansible" -f ~/.ssh/ansible
```

### 2. Configure SSH Key Permissions

```bash
# Set correct permissions for private key
chmod 600 ~/.ssh/ansible
chmod 644 ~/.ssh/ansible.pub

# Verify permissions
ls -la ~/.ssh/ansible*
```

### 3. Copy Public Key to Remote Hosts

```bash
# Method 1: Using ssh-copy-id (recommended)
ssh-copy-id -i ~/.ssh/ansible.pub user@192.168.100.88
ssh-copy-id -i ~/.ssh/ansible.pub user@192.168.100.89
```

### 4. Configure SSH Client

```bash
# Create/edit SSH configuration file
nano ~/.ssh/config
```

```ssh-config
# SSH Configuration for Ansible
Host ansible-*
    User rtaparay
    IdentityFile ~/.ssh/ansible
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600

# Specific hosts
Host k8s-master
    HostName 192.168.100.88
    User rtaparay
    IdentityFile ~/.ssh/ansible

Host k8s-worker-01
    HostName 192.168.100.89
    User rtaparay
    IdentityFile ~/.ssh/ansible
```

## Inventory Structure

### Recommended Directory Structure

```
[k8s_master]
dev-app-k8s-master-01 ansible_host=192.168.100.88 ansible_user=rtaparay ansible_ssh_private_key_file=~/.ssh/ansible

[k8s_worker]
dev-app-k8s-worker-01 ansible_host=192.168.100.89 ansible_user=rtaparay ansible_ssh_private_key_file=~/.ssh/ansible

[all:vars]  
ansible_connection=ssh
ansible_python_interpreter=/usr/bin/python3
```

# Ansible Ping Command
```
ansible k8s_master -m ping --inventory inventory/dev/hosts.ini
ansible k8s_worker -m ping --inventory inventory/dev/hosts.ini
ansible all -m ping --inventory inventory/dev/hosts.ini
```
# Copy SSH Key
```
ssh-copy-id -i ~/.ssh/ansible.pub 192.168.20.10 # remote ip
ssh-copy-id -i ~/.ssh/ansible.pub 192.168.20.11 # remote ip
ssh-copy-id -i ~/.ssh/ansible.pub 192.168.20.13 # remote ip
ssh-copy-id -i ~/.ssh/ansible.pub 192.168.20.14 # remote ip
```

# Ansible Ping Command With New SSH Key
```
ansible all -m ping --key-file ~/.ssh/ansible.pub -i hosts
```

## Remove Connected Hosts
ssh-keygen -R 192.168.100.220