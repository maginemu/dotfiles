#!/bin/bash

set -u

# this directory
readonly script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
readonly USR_LOCAL_ZSH_PATH="/usr/local/bin/zsh"

# add to standard shells
if grep -Fxq $USR_LOCAL_ZSH_PATH /etc/shells; then
    :
else
    echo "Adding ${USR_LOCAL_ZSH_PATH} into /etc/shells ..."
    echo $USR_LOCAL_ZSH_PATH | sudo tee -a /etc/shells
fi

# change login shell
chsh -s $USR_LOCAL_ZSH_PATH

# exec on zsh
$USR_LOCAL_ZSH_PATH setupprezto.sh
