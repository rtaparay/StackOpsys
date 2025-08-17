#!/bin/bash

set -e

echo "[Step 1] Actualizando el sistema..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "[Step 2] Cargando módulos del kernel..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system

echo "[Step 3] Desactivando swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

echo "[Step 4] Instalando containerd..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y containerd

echo "[Step 5] Configurando containerd..."
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
sudo systemctl status containerd

echo "[Step 6] Instalando herramientas de red..."
sudo apt-get install -y iptables arptables ebtables
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy

echo "[Step 7] Instalando kubeadm, kubelet y kubectl..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
# validar version de kubeadm antes de instalar
# apt-cache policy kubeadm | grep "Candidato:" | awk '{print $2}'
#sudo apt-get install -y kubelet=1.30.14-1.1 kubeadm=1.30.14-1.1 kubectl=1.30.14-1.1
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
sudo systemctl restart kubelet
sudo apt-mark hold kubelet kubeadm kubectl containerd

echo "[Step 8] Verificando versiones..."
kubeadm version
kubectl version --client
kubelet --version
containerd --version

echo "[DONE] El sistema está listo para usar kubeadm."