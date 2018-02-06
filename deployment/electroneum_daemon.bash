#!/bin/bash
echo "This assumes that you are doing a green-field install.  If you're not, please exit in the next 15 seconds."
sleep 15
echo "Continuing install, this will prompt you for your password if you're not already running as root and you didn't enable passwordless sudo.  Please do not run me as root!"
if [[ `whoami` == "root" ]]; then
    echo "You ran me as root! Do not run me as root!"
    exit 1
fi
cd /usr/local/src
sudo git clone https://github.com/electroneum/electroneum.git
cd electroneum
sudo git checkout
sudo curl https://raw.githubusercontent.com/arqtras/nodejs-pool/master/deployment/electroneum_daemon.patch | sudo git apply -v
sudo cmake .
sudo make -j$(nproc)
sudo cp ~/nodejs-pool/deployment/electroneum.service /lib/systemd/system/
sudo useradd -m electroneumdaemon -d /home/electroneumdaemon
BLOCKCHAIN_DOWNLOAD_DIR=$(sudo -u pooldaemon mktemp -d)
#sudo -u pooldaemon wget --limit-rate=50m -O $BLOCKCHAIN_DOWNLOAD_DIR/blockchain.raw https://downloads.getmonero.org/blockchain.raw
#sudo -u pooldaemon /usr/local/src/monero/build/release/bin/monero-blockchain-import --input-file $BLOCKCHAIN_DOWNLOAD_DIR/blockchain.raw --batch-size 20000 --database lmdb#fastest --verify off --data-dir /home/electroneumdaemon/.bitmonero
#sudo -u pooldaemon rm -rf $BLOCKCHAIN_DOWNLOAD_DIR

sudo systemctl daemon-reload
sudo systemctl enable electroneum
sudo systemctl start electroneum