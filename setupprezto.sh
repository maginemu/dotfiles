#!/usr/local/bin/zsh

set -u

readonly script_dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
readonly ZRCS_BACK_DIR=".zrcs.back"

# update zprezto repo
pushd $script_dir > /dev/null 2>&1
git submodule update --init --recursive
popd > /dev/null 2>&1


pushd $HOME > /dev/null 2>&1
if [ -d $ZRCS_BACK_DIR ]; then
    rm -rf $ZRCS_BACK_DIR
fi
mkdir -p $ZRCS_BACK_DIR

mv .zlogin .zlogout .zshenv .zshrc $ZRCS_BACK_DIR

popd > /dev/null 2>&1

# symlink prezto
if [[ -d $HOME/.zprezto ]]; then
	echo ".zprezto already exists."
else
	ln -sf $script_dir/zprezto ~/.zprezto
fi

if [[ -d $HOME/.zshrc.d ]]; then
	echo ".zshrc.d already exists."
else
	ln -sf $script_dir/zshrc.d ~/.zshrc.d
fi

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# symlink bash_profile, bashrc
ln -sf $script_dir/.bash_profile ~/.bash_profile
ln -sf $script_dir/.bashrc ~/.bashrc
