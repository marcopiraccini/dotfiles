#!/bin/bash

mkdir -p ~/.local/share/fonts

sudo apt install fontconfig
cd ~
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
mkdir -p .local/share/fonts
unzip FiraCode.zip -d .local/share/fonts
cd .local/share/fonts
rm *Windows*
cd ~
rm FiraCode.zip

fc-cache -fv
