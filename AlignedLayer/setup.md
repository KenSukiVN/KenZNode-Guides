# AlignedLayer
Chain ID: `alignedlayer`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |

Auto install :



```
sudo apt install curl -y && source <(curl -s https://raw.githubusercontent.com/KenSukiVN/KenZNode-Guides/main/AlignedLayer/auto.sh)

```


## Create wallet
```
alignedlayerd keys add wallet
```

### Faucet: https://faucet.alignedlayer.com/

### Explorer: https://explorer.alignedlayer.com/alignedlayer

### Telegram: https://t.me/aligned_layer

### Create validator
```
cd $HOME
alignedlayerd tendermint show-validator
```


Please create `validator.json`
```
nano $HOME/.alignedlayer/config/validator.json
```
```
{
    "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"xxxxxx"},
    "amount": "1000000stake",
    "moniker": "Nam",
    "identity": "06F5F34BD54AA6C7",
    "website": "https://BlockSync.com",
    "details": "BlockSync is a group of professional validators",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "1"
}
```
Edit below line `cat << EOF > $NODE_HOME/config/validator.json`

![image](https://github.com/BlockSync/BlockSync-Guides/assets/76662222/75c51844-5bf2-4dfb-a8d0-a288081a0023)

```
nano $HOME/aligned_layer_tendermint/setup_validator.sh
```
```
{
	"pubkey": $VALIDATOR_KEY,
	"amount": "$STAKING_AMOUNT",
	"moniker": $MONIKER,
	"identity": "06F5F34BD54AA6C7",
        "website": "https://BlockSync.com",
        "details": "BlockSync is a group of professional validators",
	"commission-rate": "0.1",
	"commission-max-rate": "0.2",
	"commission-max-change-rate": "0.01",
	"min-self-delegation": "1"
}
```
```
bash setup_validator.sh wallet 1050000stake
cd $HOME
```

### Command
Delegate
```
alignedlayerd tx staking delegate $(alignedlayerd keys show wallet --bech val -a) 1000000stake --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Unjail
```
alignedlayerd tx slashing unjail --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Edit validator
```
alignedlayerd tx staking edit-validator \
--new-moniker "Name-BlockSync" \
--identity "06F5F34BAA6C7" \
--website "https://BlockSync.com" \
--details "BlockSync is a group of professional validators" \
--security-contact "email" \
--chain-id alignedlayer \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake \
-y
```

### Remove Node
```
cd $HOME
sudo systemctl stop alignedlayer
sudo systemctl disable alignedlayer
sudo rm /etc/systemd/system/alignedlayer.service
sudo systemctl daemon-reload
sudo rm -f $(which alignedlayer)
sudo rm -rf $HOME/.alignedlayer
```