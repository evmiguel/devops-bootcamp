#!/bin/bash

sudo apt update
sudo apt install -y nodejs npm

wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz
tar -xzvf bootcamp-node-envvars-project-1.0.0.tgz

export APP_ENV=dev
export DB_USER=myuser
export DB_PWD=mysecret

cd package

npm install
node server.js &

ps aux | grep node | grep -v grep
netstat -tunalp | grep 3000
