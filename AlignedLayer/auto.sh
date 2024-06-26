#!/bin/bash
clear

if [[ ! -f "$HOME/.bash_profile" ]]; then
    touch "$HOME/.bash_profile"
fi

if [ -f "$HOME/.bash_profile" ]; then
    source $HOME/.bash_profile
fi



echo "===========Aligned Layer Install Easy======= " && sleep 1

read -p "Do you want run node Aligned Layer ? (y/n): " choice

if [ "$choice" == "y" ]; then


sudo apt update && sudo apt upgrade -y
sudo apt install make curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

#Install GO
ver="1.21.5"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

cd $HOME
wget https://github.com/yetanotherco/aligned_layer_tendermint/releases/download/v0.1.0/alignedlayerd
chmod +x alignedlayerd
sudo mv alignedlayerd /usr/local/bin/
cd $HOME
alignedlayerd version

NODE_HOME=$HOME/.alignedlayer
CHAIN_BINARY=alignedlayerd
CHAIN_ID=alignedlayer
PEER_ADDRESSES=("91.107.239.79" "116.203.81.174" "88.99.174.203" "128.140.3.188")

$CHAIN_BINARY init NodeName \
    --chain-id $CHAIN_ID --overwrite

curl -Ls https://raw.githubusercontent.com/nodesynctop/Alignedlayer/main/genesis.json > $HOME/.alignedlayer/config/genesis.json
curl -Ls https://raw.githubusercontent.com/nodesynctop/Alignedlayer/main/addrbook.json > $HOME/.alignedlayer/config/addrbook.json


for ADDR in "${PEER_ADDRESSES[@]}"; do
    GENESIS=$(curl -f "$ADDR:26657/genesis" | jq '.result.genesis')
    if [ -n "$GENESIS" ]; then
        echo "$GENESIS" > $NODE_HOME/config/genesis.json;
        break;
    fi
done

for ADDR in "${PEER_ADDRESSES[@]}"; do
    PEER_ID=$(curl -s "$ADDR:26657/status" | jq -r '.result.node_info.id')
    if [ -n "$PEER_ID" ]; then
        PEERS+=("$PEER_ID@$ADDR:26656")
    fi
done

PEER_LIST=$(IFS=,; echo "${PEERS[*]}")

$CHAIN_BINARY config set config p2p.persistent_peers "$PEER_LIST" --skip-validate
$CHAIN_BINARY config set config rpc.laddr "tcp://0.0.0.0:26657" --skip-validate

sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:24210\"|" $HOME/.alignedlayer/config/config.toml

#sed -i -e 's|^persistent_peers *=.*|persistent_peers ="dc2011a64fc5f888a3e575f84ecb680194307b56@148.251.235.130:20656,a1a98d9caf27c3363fab07a8e57ee0927d8c7eec@128.140.3.188:26656,1beca410dba8907a61552554b242b4200788201c@91.107.239.79:26656,f9000461b5f535f0c13a543898cc7ac1cd10f945@88.99.174.203:26656, 32fbefec592ac2ff9ecb3cad69bafaaad01e771a@148.251.235.130:20656,81138177a67195791bbe782fe1ed49f25e582bac@91.107.239.79:26656,c5d0498e345725365c1016795eecff4a67e4c4c9@88.99.174.203:26656,14af04afc663427604e8dd53f4023f7963a255cb@116.203.81.174:26656,9c89e77d51561c8b23957eee85a81ccc99fa7d6b@128.140.3.188:26656,c355b86c882d05a83f84afba379291d7b954b28f@65.108.236.43:26656,b499b9eb88c1c78ae25fdc7c390090f7542160eb@167.235.12.38:26656,18e1adeadb8cc596375e4212288fcd00690df067@213.199.48.195:26656,6d7adb46e588bea496f33758e0448bf84e308b39@143.244.178.205:26656,de193ba0ae387fc7892c2ead7458202f1c035d69@38.242.137.235:26656"|' $HOME/.alignedlayer/config/config.toml

peers=$(curl -s https://raw.githubusercontent.com/nodesynctop/Alignedlayer/main/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.alignedlayer/config/config.toml

sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001stake\"|" $HOME/.alignedlayer/config/app.toml

sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.alignedlayer/config/app.toml

sudo tee /etc/systemd/system/alignedlayerd.service > /dev/null <<EOF
[Unit]
Description=alignedlayerd
After=network-online.target
[Service]
User=root
ExecStart=$(which alignedlayerd) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
cd $HOME

cd $HOME
sudo systemctl daemon-reload
sudo systemctl enable alignedlayerd
sudo systemctl restart alignedlayerd
sudo journalctl -u alignedlayerd -f --no-hostname -o cat


echo "===================Install Success==================="

else

echo "Not installed"

fi

