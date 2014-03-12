#!/bin/bash

# this directory
script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

# install oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh || 0

# remove once
mv ~/.zshrc ~/.zshrc.oh-my-zsh.bak

# symlink zshrc
ln -sf $script_dir/zshrc.d ~/.zshrc.d
ln -sf $script_dir/.zshrc ~/.zshrc

# symlink bash_profile, bashrc
ln -sf $script_dir/.bash_profile ~/.bash_profile
ln -sf $script_dir/.bashrc ~/.bashrc
