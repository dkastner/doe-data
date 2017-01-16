#!/bin/bash
set -euo pipefail

cd $HOME/data

tmux -c 'wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains eia.gov --no-parent https://www.eia.gov'
