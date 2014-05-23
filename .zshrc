# .zshrcがあるディレクトリのパスを取得する
# source: http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
ZSHRCDIR=$(cd "$(dirname "$0")"; pwd)

# Path to your oh-my-zsh configuration.
ZSH=${ZSHRCDIR}/.zsh/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="wedisagree"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

# functions
load_file_if_exists() {
    if [ -f $1 ]; then
        source $1
    fi
}

# 基本設定{{{1
# 表示言語設定
export LANG=ja_JP.UTF-8
setopt print_eight_bit

# PATHの設定
export PATH=/usr/local/sbin:${PATH}
export PATH=/usr/local/bin:${PATH}
export PATH=/usr/sbin:${PATH}
export PATH=/usr/bin:${PATH}
export PATH=/sbin:${PATH}
export PATH=/bin:${PATH}
export PATH=${ZSHRCDIR}/local/bin:${PATH}
typeset -U path PATH

# 補完機能強化
autoload -U compinit; compinit
# 補完候補を一覧で表示
setopt auto_list 
# 補完キー連打で補完候補を順に表示
setopt auto_menu 
# 補完候補をできるだけ詰めて表示
setopt list_packed 
# 補完候補にファイルの種類も表示
setopt list_types

# 正規表現強化
setopt EXTENDED_GLOB

# ディレクトリ名のみで移動可能にする
setopt auto_cd
# 移動したディレクトリを記録
setopt auto_pushd

# historyの設定
HISTFILE=${ZSHRCDIR}/.zsh/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history
setopt append_history
setopt hist_no_store
setopt hist_ignore_dups
# }}}

# エイリアス{{{1
alias vim='vim -u ${ZSHRCDIR}/.vimrc'
alias vi='vim -u ${ZSHRCDIR}/.vimrc'
alias v='vim -u ${ZSHRCDIR}/.vimrc'
alias gs='git status -sb'
alias gcb='git checkout -b'
alias gc='git commit'
alias ga='git add'
alias gpo='git push origin'
alias gd='git diff'
alias g='git'
# }}}

# Github api token for Homebrew
export HOMEBREW_GITHUB_API_TOKEN=600d6125e44b1fcfdfc4adc3f38a588c0eefbce1

# rbenv
export PATH=${ZSHRCDIR}/.rbenv/bin:${ZSHRCDIR}/.rbenv/shims:${PATH}
eval "$(rbenv init - zsh)"

# phpenv
export PATH=${ZSHRCDIR}/.phpenv/bin:${ZSHRCDIR}/.phpenv/shims:${PATH}
eval "$(phpenv init - zsh)"

# ターミナルの定義
export TERM=xterm-256color

# 外部ファイルの読み込み{{{1
load_file_if_exists "${ZSH}/oh-my-zsh.sh"
load_file_if_exists "${ZSHRCDIR}/.zshrc.local"
# }}}
