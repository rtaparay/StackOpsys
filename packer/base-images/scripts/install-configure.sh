#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

# Limpiar y reparar apt al inicio
sudo apt-get clean
sudo dpkg --configure -a
sudo apt-get update --fix-missing -y

cleanup() {
    echo "Error detectado, limpiando..."
    sudo apt-get clean
    sudo dpkg --configure -a
    exit 1
}
trap cleanup ERR

echo "[Step 1] Actualizando el sistema..."
sudo apt-get update -y
sudo apt-get upgrade -y


echo "[Step 2] Configurando firewalld..."
sudo apt install firewalld -y
sudo systemctl enable firewalld
sudo systemctl start firewalld
echo "Habilitar los puertos necesarios para kubernetes"
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=2379-2380/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --add-port=10251/tcp
sudo firewall-cmd --permanent --add-port=10252/tcp
sudo firewall-cmd --permanent --add-port=10255/tcp
sudo firewall-cmd --reload

echo "[Step 3] Instalando y configurando herramientas de red..."
echo "habilitar el modo heredado (legacy) para iptables"
sudo apt-get install iptables arptables ebtables -y
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

echo "[Listo] El sistema está listo para instalar y configurar kubernetes."
