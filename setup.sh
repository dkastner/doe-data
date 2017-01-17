#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y wget tmux git

curl -OL https://github.com/git-lfs/git-lfs/releases/download/v1.5.5/git-lfs-linux-amd64-1.5.5.tar.gz
tar -zxvf git-lfs-linux-amd64-1.5.5.tar.gz
cd git-lfs-linux-amd64-1.5.5
sudo bash install.sh

cd $HOME

git config --global user.email "dkastner+scraper@gmail.com"
git config --global user.name "The Scraper"

#sudo bundle install
