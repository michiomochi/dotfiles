# Mac

## Setup

1, Install Xcode from app store

2, Install command line tool

- https://developer.apple.com/downloads/

3, Sign to xcode license, and install command line tools

```
> sudo xcodebuild -license
> xcode-select --install
```

4, Modify mac name

- System preferences > Sharing

5, Mute alert sound

- System preferences > Sounds > Sounds effect > Mute

6, Install java

- Install from below link
  + http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

7, Apply itamae-local

- Install homebrew
- Prepare itamae execution environment
  - Install rbenv
  - Install ruby
  - Install bundler
- Download dotfiles repository
- Apply itamae
- Change default shell to zsh

```
> ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
> brew install rbenv
> rbenv install 2.3.1
> ghq get git@github.com:michiomochi/dotfiles.git
> cd ~/.ghq/github.com/michiomochi/dotfiles
> bin/itamae-local
> chsh -s $(which zsh)
```
