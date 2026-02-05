#!/usr/bin/env bash
# Initialize microvm workspace directory and SSH keys

set -e

VM_NAME=${1:-coder}
WORKSPACE_DIR="$HOME/virt-machines/microvm/$VM_NAME"
SSH_KEYS_DIR="$WORKSPACE_DIR/ssh-host-keys"

# Create directories
mkdir -p "$WORKSPACE_DIR"
mkdir -p "$SSH_KEYS_DIR"

# Generate SSH host keys if they don't exist
if [ ! -f "$SSH_KEYS_DIR/microvm_ssh_host_ed25519_key" ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -t ed25519 -N "" -f "$SSH_KEYS_DIR/microvm_ssh_host_ed25519_key" -C "$VM_NAME"
    ssh-keygen -t rsa -b 4096 -N "" -f "$SSH_KEYS_DIR/microvm_ssh_host_rsa_key" -C "$VM_NAME"
fi

echo "Workspace initialized at: $WORKSPACE_DIR"
echo "SSH host keys at: $SSH_KEYS_DIR"
echo ""
echo "To start the microvm:"
echo "  sudo systemctl start microvm@$VM_NAME"
echo ""
echo "To SSH into the microvm:"
echo "  ssh gotlou@192.168.83.2"
