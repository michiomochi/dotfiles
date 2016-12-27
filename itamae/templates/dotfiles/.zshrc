#!/usr/bin/env zsh -ex

# functions
load_file_if_exists() {
  if [ -f $1 ]; then
      source $1
  fi
}

# PATH
export PATH=/usr/sbin:${PATH}
export PATH=/usr/bin:${PATH}
export PATH=/sbin:${PATH}
export PATH=/bin:${PATH}
export PATH=/usr/local/heroku/bin:${PATH}
export PATH=/usr/local/sbin:${PATH}
export PATH=/usr/local/bin:${PATH}
export PATH=${HOME}/local/bin:${PATH}
typeset -U path PATH

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
function select_history_by_peco() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(\history -n 1 | \
    eval $tac | \
    peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N select_history_by_peco
bindkey '^r' select_history_by_peco

# Aliases
alias be='bundle exec'
alias cp='cp -i'
alias l='ls -v -A -G'
alias la='ls -A -G'
alias ll='ls -l -a -G'
alias ls="gls -F --color=auto"
alias ga='git add'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit -v --amend'
alias gch='git checkout'
alias gd='git diff'
alias gg='git grep -n'
alias ghl='ghq look'
alias gl='git pull'
alias glg='git log --stat'
alias glr='git pull --rebase'
alias gp='git push -u'
alias grh='git reset HEAD'
alias gss='git status -s'
alias gst='git status -sb'
alias mv='mv -i -v'
alias rm='rm -i'
alias rs='bundle exec rails server -b 0.0.0.0'
alias vi='vim'

setopt no_complete_aliases

# Prompts
autoload colors && colors
local currentTime='%W %*'
local currentDir='%/'
local userName='%n'
local hostName='%M'
PROMPT="%B%F{red}${userName}@${hostName}%f%b"$'\n'"%B%F{blue}[${currentDir}]%f%b"$'\n'"> "

# rbenv
export PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}
eval "$(rbenv init - zsh)"

# nodebrew
export PATH=${HOME}/.nodebrew/current/bin:${PATH}

# ターミナルの定義
export TERM=xterm-256color

# load tmuxinator
#source ${HOME}/.tmuxinator/tmuxinator.zsh

# direnv
eval "$(direnv hook zsh)"
