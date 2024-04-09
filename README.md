# Namada services

## Recommend environments
<p style="background:black;color:white;padding:10px;border-radius:6px">
export PATH=$HOME/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin<br />
export PATH=/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:$HOME/go/bin<br />
export BASE_DIR=$HOME/.local/share/namada<br />
export NAMADA_TAG="Namada Release Tag"<br />
export TM_HASH=v0.1.4-abciplus<br />
export CHAIN_ID="public-testnet-15.0dacadb8d663"<br />
export PUBLIC_IP="PUBLIC IP"<br />
export IP_PORT="PUBLIC IP:26656"<br />
export VALIDATOR_ALIAS="VALIDATOR MONIKER"<br />
</p>

## Run node as service
#### Edit service file
sudo vi /etc/systemd/system/namadad.service
<p style="background:black;color:white;padding:10px;border-radius:6px">
[Unit]<br />
Description=namada<br />
After=network-online.target<br />

[Service]<br />
User=namadanet<br />
WorkingDirectory=/home/namadanet/.local/share/namada<br />
Environment="NAMADA_LOG=info"<br />
Environment="CMT_LOG_LEVEL=p2p:none,pex:error"<br />
Environment="NAMADA_CMT_STDOUT=true"<br />
ExecStart=/usr/local/bin/namada --base-dir=/home/namadanet/.local/share/namada node ledger run<br />
StandardOutput=syslog<br />
StandardError=syslog<br />
Restart=on-failure<br />
RestartSec=3<br />
LimitNOFILE=65535<br />
<br />
[Install]<br />
WantedBy=multi-user.target<br />
</p>

#### Enable and start service
<p style="background:black;color:white;padding:10px;border-radius:6px">
sudo chmod 755 /etc/systemd/system/namadad.service<br />
sudo systemctl daemon-reload<br />
sudo systemctl enable namadad<br />
sudo systemctl start namadad && sudo journalctl -u namadad -n 1000 -f<br />
</p>

### Service commands
<p style="background:black;color:white;padding:10px;border-radius:6px">
sudo service namadad start<br />
sudo service namadad status<br />
sudo service namadad stop<br />
sudo service namadad restart<br />
</p>

## Node Services

#### Public RPC: 
<p style="background:black;color:white;padding:10px;border-radius:6px">
https://namada-se.staking_power.com/
</p>

#### Indexer Service: 
<p style="background:black;color:white;padding:10px;border-radius:6px">
https://indexer.staking_power.com/
</p>

#### Genesis:
<p style="background:black;color:white;padding:10px;border-radius:6px">
https://files.somewhere.com/genesis.json
</p>

#### Add seed:
<p style="background:black;color:white;padding:10px;border-radius:6px">
seeds="tcp://ip:port<br />
sed -i "s#^seeds *=.*#seeds = \"$seeds\"#;" $BASE_DIR/$CHAIN_ID/config.toml
</p>

#### Add peer:
<p style="background:black;color:white;padding:10px;border-radius:6px">
peers="tcp://ip:port"<br />
sed -i "s#^persistent_peers *=.*#persistent_peers = \"$peers\"#;" $BASE_DIR/$CHAIN_ID/config.toml
</p>

#### Address book:
<p style="background:black;color:white;padding:10px;border-radius:6px">
wget -qO $BASE_DIR/$CHAIN_ID/cometbft/config/addrbook.json https://snapshots.theamsolutions.info/nam-addrbook.json
</p>

### Snapshot:
#### Stop the service and reset the data
<p style="background:black;color:white;padding:10px;border-radius:6px">
sudo systemctl stop namada.service<br />
cp $BASE_DIR/$CHAIN_ID/cometbft/data/priv_validator_state.json $BASE_DIR/$CHAIN_ID/priv_validator_state.json.backup<br />
rm -rf $BASE_DIR/$CHAIN_ID/cometbft/data $BASE_DIR/$CHAIN_ID/db $BASE_DIR/$CHAIN_ID/wasm
</p>

#### Download latest snapshot
<p style="background:black;color:white;padding:10px;border-radius:6px">
wget -P $BASE_DIR/somewhere https://files.somewhere.com/namada-snapshot.tar.gz<br />
tar -zcvf namada-snapshot.tar.gz<br />
</p>

#### Restart service
<p style="background:black;color:white;padding:10px;border-radius:6px">
sudo systemctl restart namadad && sudo journalctl -u namada.service -fn 100 -o cat
</p>

## Useful scripts
#### Voting script
<p style="background:black;color:white;padding:10px;border-radius:6px">
wget https://www.somewhere.com/namada_voting.sh<br />
chmod +x namada_voting.sh<br />
./namada_voting.sh
</p>
