#!/bin/sh

# Install node js
sudo apt-get update
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install pm2
sudo npm install -g pm2

# Configure pm2 to run hellonode on startup
mkdir -p ~/src
mv /tmp/src ~

cd  ~/src
npm install

sudo pm2 start server.js
sudo pm2 startup systemd
sudo pm2 save
sudo pm2 list
