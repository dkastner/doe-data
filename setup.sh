#!/bin/bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y wget tmux git

git config --global user.email "dkastner+scraper@gmail.com"
git config --global user.name "The Scraper"

cd $HOME

#sudo bundle install
