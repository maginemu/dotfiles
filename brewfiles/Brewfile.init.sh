#!/bin/bash

# Make sure using latest Homebrew
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# upgrade

# Add Repository
brew tap homebrew/versions || true
brew tap phinze/homebrew-cask || true
brew tap homebrew/binary || true
brew tap sanemat/font || true

#
# Packages
#
brew install zsh
brew install git
brew install wget
brew install httpie
brew install tree
brew install ag
brew install peco
brew install git-now
brew install coreutils # gls etc

# python
brew install python

# node
brew install nodebrew

# ruby
brew install rbenv ruby-build

brew install docker
brew install boot2docker

# emacs
brew install --with-cocoa emacs
brew install cmigemo
brew install doxymacs

# servers
brew install redis

# .dmg
brew cask install iterm2
brew cask install virtualbox # may needs password
brew cask install vagrant
brew cask install google-japanese-ime
brew cask install karabiner
brew cask install dropbox
brew cask install transmit
brew cask install atom
brew cask install xquartz

# requires xquartz
brew install --powerline --vim-powerline ricty

# Remove outdated packages
brew cleanup
