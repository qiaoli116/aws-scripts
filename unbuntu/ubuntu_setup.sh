#!/bin/sh
echo "Installing Ubuntu packages..."
sudo apt-get update
sudo apt-get upgrade -y
# install unzip
sudo apt-get install -y unzip
# install git
sudo apt-get install -y git
# install nodejs !! if nodejs version is not right, use nvm to install node
# sudo apt-get install -y nodejs
wget https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh
bash install.sh
source ~/.bashrc
nvm install v18
# install npm
sudo apt-get install -y npm
# install python3
sudo apt-get install -y python3
# install pip3
sudo apt-get install -y python3-pip
# install pipenv
sudo pip3 install pipenv
# install docker
sudo apt-get install -y docker.io
# install docker-compose
sudo apt-get install -y docker-compose
# install curl
sudo apt-get install -y curl
# install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws
# install aws cdk
npm install -g aws-cdk
# install ssh
sudo apt install openssh-server
sudo systemctl start ssh
sudo systemctl enable ssh


