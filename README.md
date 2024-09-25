# Hemi CLI PoP-Miner

### Install
```sh
wget -O cli.sh https://raw.githubusercontent.com/aethjuice/hemi/main/cli.sh && chmod +x cli.sh && ./cli.sh
```

### Take your Private Key and Pubkey TBTC (Legacy address) and Take Faucet
```
cat ~/popm-address.json
```

- Join Discord : https://discord.gg/hemixyz
- Take your faucet on channel [💧| Faucet ]
- Claim Faucet tBTC on Hemi Discord Channel 
- Use Pubkey Hash Address

### Restart Your CLI
```sh
sudo systemctl restart heminetwork
```
### Check Logs
```sh
journalctl -u heminetwork -f
```

### Check explorer
- https://pop-miner.hemi.xyz/fund
- Paste Private Key


### Stop the node
```
sudo systemctl stop heminetwork && \
sudo systemctl disable heminetwork && \
sudo rm /etc/systemd/system/heminetwork.service && \
sudo systemctl daemon-reload
```

### Author
- Aomine | https://discord.gg/aetherealco
- Docs: https://docs.hemi.xyz/how-to-tutorials/tutorials/setup-part-1

