#!/bin/bash

log() {
  local level="$1"
  local message="$2"
  echo "[$level] $message"
}

echo "Installing required packages"
if ! command_exists wget; then
  # Likely Debian/Ubuntu system
  sudo apt-get update
  sudo apt-get install -y wget
elif ! command_exists yum; then
  # Likely RHEL/CentOS system
  sudo yum update -y
  sudo yum install -y wget
fi

if ! command_exists tar; then
  sudo apt-get install -y tar  # For Debian/Ubuntu
  sudo yum install -y tar # For RHEL/CentOS
fi

if ! command_exists jq; then
  sudo apt-get install -y jq  # For Debian/Ubuntu
  sudo yum install -y jq  # For RHEL/CentOS
fi

echo "Downloading Hemi CLI"
wget -q https://github.com/hemilabs/heminetwork/releases/download/v0.4.3/heminetwork_v0.4.3_linux_amd64.tar.gz

echo "Extracting Hemi CLI"
tar -xvf heminetwork_v0.4.3_linux_amd64.tar.gz
rm heminetwork_v0.4.3_linux_amd64.tar.gz
cd heminetwork_v0.4.3_linux_amd64

echo "Generating wallet"
./keygen -secp256k1 -json -net="testnet" > $HOME/popm-address.json

echo "Extract wallet"
PRIVATE_KEY=$(jq -r '.private_key' $HOME/popm-address.json)

if [ -z "$PRIVATE_KEY" ]; then
  log ERROR "Private key not found in popm-address.json"
  exit 1
fi

SERVICE_FILE="/etc/systemd/system/heminetwork.service"
echo "Creating systemd service"
cat <<EOF | sudo tee $SERVICE_FILE
[Unit]
Description=Hemilabs Network Node
After=network.target

[Service]
User=$(whoami)
Group=$(id -g -n)
WorkingDirectory=$(pwd)
ExecStart=$(pwd)/popmd
Environment="POPM_BTC_PRIVKEY=$PRIVATE_KEY"
Environment="POPM_STATIC_FEE=50"
Environment="POPM_BFG_URL=wss://testnet.rpc.hemi.network/v1/ws/public"
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "Restart systemd and enable Hemi service"
sudo systemctl daemon-reload
sudo systemctl enable heminetwork
sudo systemctl start heminetwork

echo -e "\e[32mJoin our discord https://discord.gg/aetherealco"
echo -e "\e[0m"

echo "Check status Hemi service"
sudo systemctl status heminetwork
