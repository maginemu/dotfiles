#!/bin/sh# Make sure using latest Homebrew
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# upgrade

# Add Repository
brew tap homebrew/versions || true
brew tap phinze/homebrew-cask || true
brew tap homebrew/binary || true

# Packages
brew install zsh
brew install git
brew install wget
brew install tree
brew install nvm
brew install --cocoa emacs
brew install git-now
brew install docker
brew install boot2docker

# .dmg
brew cask install iterm2
brew cask install virtualbox # may needs password
brew cask install vagrant
brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install karabiner
brew cask install kobito
brew cask install skype
brew cask install dropbox
brew cask install transmit
brew cask install hipchat
brew cask install evernote
brew cask install atom

# Remove outdated packages
brew cleanup
