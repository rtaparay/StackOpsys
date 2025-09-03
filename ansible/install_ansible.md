# Ansible Installation Manual

This guide provides complete instructions for installing Ansible on different operating systems and installation methods.

## Table of Contents
- [Ubuntu Linux](#ubuntu-linux)
- [macOS](#macos)
- [Python/pip Installation](#pythonpip-installation)
- [Installation Verification](#installation-verification)
- [Specific Version Installation](#specific-version-installation)

## Ubuntu Linux

### Method 1: Official Ansible Repository (Recommended)

```bash
# Update repositories
sudo apt update

# Install dependencies
sudo apt install software-properties-common

# Add official Ansible repository
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt install ansible
```

### Method 2: Ubuntu Default Repositories

```bash
# Update repositories
sudo apt update

# Install Ansible from default repositories
sudo apt install ansible
```

**Note:** This method may install an older version of Ansible.

## macOS

### Method 1: Homebrew (Recommended)

```bash
brew install ansible
```

## Python/pip Installation

### Prerequisites

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv

# macOS (if you don't have Python 3)
brew install python3
```

### Global Installation

```bash
# Update pip
python3 -m pip install --upgrade pip

# Install Ansible
pip3 install ansible

# Or using python3 -m pip
python3 -m pip install ansible
```

### Virtual Environment Installation (Recommended)

```bash
# Create virtual environment
python3 -m venv ansible-env

# Activate virtual environment
# On Linux/macOS:
source ansible-env/bin/activate

# Install Ansible in virtual environment
pip install ansible

# To deactivate virtual environment
deactivate
```

## Installation Verification

```bash
# Check Ansible version
ansible --version

# Check ansible-playbook version
ansible-playbook --version

# List available modules
ansible-doc -l

# Test local connectivity
ansible localhost -m ping
```

## Specific Version Installation

### Uninstall Current Version (if necessary)

```bash
# Ubuntu (repository)
sudo apt remove ansible

# macOS (Homebrew)
brew uninstall ansible

# Python/pip
pip3 uninstall ansible
```

### Install Specific Version with pip

```bash
# Install specific version
pip3 install ansible==6.7.0

# Install LTS version (2.9.x)
pip3 install "ansible>=2.9,<2.10"

# Install latest version of a major series
pip3 install "ansible>=7.0,<8.0"
```

### List Available Versions

```bash
# View available Ansible versions
pip3 index versions ansible

# Or using pip search (if available)
pip3 search ansible
```

## Additional Configuration

### Configuration File

```bash
# Create configuration directory
mkdir -p ~/.ansible

# Create basic configuration file
cat > ~/.ansible/ansible.cfg << EOF
[defaults]
host_key_checking = False
inventory = ./inventory
remote_user = ansible
private_key_file = ~/.ssh/id_rsa

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
EOF
```

### Configure SSH for Ansible

```bash
# Generate SSH key if it doesn't exist
ssh-keygen -t rsa -b 4096 -C "ansible@$(hostname)"

# Copy public key to remote hosts
ssh-copy-id user@remote-host
```

## Common Troubleshooting

### Permission Errors on macOS

```bash
# If you encounter permission errors, use:
pip3 install --user ansible
```

### Update Ansible

```bash
# Ubuntu (repository)
sudo apt update && sudo apt upgrade ansible

# macOS (Homebrew)
brew upgrade ansible

# Python/pip
pip3 install --upgrade ansible
```

### Verify Dependencies

```bash
# Verify Python dependencies
python3 -c "import ansible; print(ansible.__version__)"

# Verify Ansible modules
ansible-doc -t module -l | head -10
```

## Additional Resources

- [Official Ansible Documentation](https://docs.ansible.com/)
- [Official Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/)
- [Ansible Galaxy](https://galaxy.ansible.com/)
- [Ansible GitHub](https://github.com/ansible/ansible)

---

**Note:** It is recommended to use Python virtual environments to avoid dependency conflicts and maintain clean and organized installations.
