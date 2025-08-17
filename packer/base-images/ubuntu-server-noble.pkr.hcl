# Packer Template to create an Ubuntu Server (Noble 24.04) on Proxmox

# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-server-noble" {
    proxmox_url = var.proxmox_api_url
    username = var.proxmox_api_token_id
    token = var.proxmox_api_token_secret
    insecure_skip_tls_verify = true

    node = var.proxmox_node
    vm_id = var.vm_id
    vm_name = var.vm_name
    template_description = var.template_description
    iso_file = var.iso_file
    iso_storage_pool = var.iso_storage_pool
    unmount_iso = true

    qemu_agent = true  # Habilitar soporte para QEMU agent
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size = var.disk_size
        format = "qcow2"
        storage_pool = var.storage_pool
        storage_pool_type = "lvm"
        type = "virtio"
    }

    cores = var.cores
    memory = var.memory
    network_adapters {
        model = "virtio"
        bridge = var.network_bridge
        firewall = "false"
    }

    cloud_init = true
    cloud_init_storage_pool = "directory"

    boot_command = [
        "<esc><wait>",
        "e<wait>",
        "<down><down><down><end>",
        "<bs><bs><bs><bs><wait>",
        "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
        "<f10><wait>"
    ]

    boot = "c"
    boot_wait = "15s"
    communicator = "ssh"
    http_directory = "http"

    ssh_username = var.ssh_username
    ssh_password = var.ssh_password
    ssh_private_key_file = var.ssh_private_key_file
    ssh_timeout = "15m"
    ssh_handshake_attempts = 100 # intentos de conexión
    ssh_pty = true
}

# Build Definition to create the VM Template
build {
    name = "ubuntu-server-noble"
    sources = ["source.proxmox-iso.ubuntu-server-noble"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
    provisioner "shell" {
        inline = [
            "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm /etc/ssh/ssh_host_*",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo apt -y autoremove --purge",
            "sudo apt -y clean",
            "sudo apt -y autoclean",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    provisioner "file" {
        source = "files/99-pve.cfg"
        destination = "/tmp/99-pve.cfg"
    }
    provisioner "shell" {
        inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
    }


    # Provisioning the VM Template with Kubernetes and Kubeadm Installation #3
    provisioner "file" {
        source = "scripts/install-kubeadm.sh"
        destination = "/tmp/install-kubeadm.sh"
    }
    provisioner "shell" {
        inline = [
            "chmod +x /tmp/install-kubeadm.sh",
            "/tmp/install-kubeadm.sh"
        ]
    }
}
