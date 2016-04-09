# functions {{{1
load_file_if_exists() {
    if [ -f $1 ]; then
        source $1
    fi
}
# }}}
# oh-my-zsh {{{1
# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=${HOME}/.zsh/custom

ZSH_THEME="wedisagree"
DISABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git autojump history-substring-search rbenv cp rsync brew)

source ${ZSH}/oh-my-zsh.sh
# }}}
# PATH {{{1
    export PATH=/usr/sbin:${PATH}
    export PATH=/usr/bin:${PATH}
    export PATH=/sbin:${PATH}
    export PATH=/bin:${PATH}
    export PATH=/usr/local/heroku/bin:${PATH}
    export PATH=/usr/local/sbin:${PATH}
    export PATH=/usr/local/bin:${PATH}
    export PATH=${HOME}/local/bin:${PATH}
    typeset -U path PATH
# }}}
# general {{{1
# 表示言語設定
export LANG=en_US.UTF-8
setopt print_eight_bit

# 補完機能強化
fpath=($(brew --prefix)/share/zsh/functions $fpath)
autoload -U compinit; compinit
# 補完候補を一覧で表示
setopt auto_list
# 補完キー連打で補完候補を順に表示
setopt auto_menu
# 補完候補をできるだけ詰めて表示
setopt list_packed
# 補完候補にファイルの種類も表示
setopt list_types
# 補完候補にaliasを含める
setopt complete_aliases

# 正規表現強化
setopt EXTENDED_GLOB

# ディレクトリ名のみで移動可能にする
setopt auto_cd
# 移動したディレクトリを記録
setopt auto_pushd
# emacsキーバインド
bindkey -e

# ログアウトしてもバックグラウンドジョブを続ける
setopt NOHUP

# historyの設定
HISTFILE=${HOME}/.zsh-history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt append_history
setopt hist_no_store
setopt hist_ignore_dups

# pecoを使用したincremental searchの有効化
source ${HOME}/.zsh/select_history_by_peco.sh
zle -N select_history_by_peco
bindkey '^r' select_history_by_peco
# }}}
# aliases {{{1
case "${OSTYPE}" in
    # Mac
    darwin*)
        alias ls="gls -F --color=auto"
        alias ll='ls -l -a -G'
        alias la='ls -A -G'
        alias l='ls -v -A -G'
        alias updatedb='/usr/libexec/locate.updatedb'
        ;;
    # Linux
    linux*)
        alias ls="ls -v -F --color=auto"
        alias ll='ls -l -a --color=auto'
        alias la='ls -A --color=auto'
        alias l='ls -v -A --color=auto'
        ;;
esac
alias vi='vim'
alias gst='git status -sb'
alias gch='git checkout'
alias gp='git push -u'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i -v'
alias j='jobs'
alias be='bundle exec'
alias weather='curl -4 wttr.in/Tokyo'

setopt no_complete_aliases

# prompts {{{1
autoload colors && colors
local currentTime='%W %*'
local currentDir='%/'
local userName='%n'
local hostName='%M'
PROMPT="%B%F{red}${userName}@${hostName}%f%b"$'\n'"%B%F{blue}[${currentDir}]%f%b"$'\n'"> "
# }}}

# rbenv
export PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}
eval "$(rbenv init - zsh)"
# ターミナルの定義
export TERM=xterm-256color
# import local settings
[ -s ${HOME}/.zshrc.local ] && source ${HOME}/.zshrc.local

# load tmuxinator
source ${HOME}/.tmuxinator/tmuxinator.zsh

# direnv
eval "$(direnv hook zsh)"

# vim: foldmethod=marker
# vim: foldcolumn=3
# vim: foldlevel=0
