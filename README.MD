# Collection of zsh / vim configurations.
Partially inspired by: https://github.com/lucasfcosta/dotfiles

**This is configured for Linux** (so no fancy OSx stuff :) but the goal is to have a common configuration that I can use in both Ubuntu and OSx.
It's also pretty basic since it assumes that everything (oh_my_zsh, nvim, etc), is already installed since will be installed in different way depending on the OS


## Installation of oh-my-zsh plugins

```bash

git clone https://github.com/z-shell/nb.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/nb
```

## Install ssh keys
This must be done manually copying yhe .ssh folder to the home directory

## Install Astronvim    
https://docs.astronvim.com/#-installation


## Install nb 
https://xwmx.github.io/nb/#installation

## Install Rust

Rust analyzer: 
```bash
rustup component add rust-analyzer
```

## Install utilities

For the fin in astornvim to work, you need to install ripgrep
```bash
sudo apt install ripgrep
sudo apt install gdu
``` 

Install bottom:
```bash
https://github.com/ClementTsang/bottom?tab=readme-ov-file#debian--ubuntu
```
