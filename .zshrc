# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export LANG=ja_JP.UTF-8
setopt print_eight_bit
setopt no_flow_control

export PATH=/usr/local/bin:$PATH

# Github api token for Homebrew
export HOMEBREW_GITHUB_API_TOKEN=600d6125e44b1fcfdfc4adc3f38a588c0eefbce1

# rbenv
export PATH=$HOME/.rbenv/shims:$PATH
eval "$(rbenv init - zsh)"

# phpenv
export PATH=$HOME/.phpenv/bin:$PATH
eval "$(phpenv init - zsh)"

# golang
export GOROOT=/usr/local/Cellar/go/1.1.2
export GOPATH=$HOME/Dev/Go
export PATH=$GOPATH/bin:$PATH

# extend regex
setopt EXTENDED_GLOB
