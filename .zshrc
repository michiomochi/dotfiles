# Path to your oh-my-zsh configuration.
ZSH=${HOME}/.zsh/oh-my-zsh

# .zshrcがあるディレクトリのパスを取得する
# source: http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
ZSHRCDIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

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
    export PATH=/usr/local/sbin:$PATH
    export PATH=/usr/local/bin:$PATH
    export PATH=/usr/sbin:$PATH
    export PATH=/usr/bin:$PATH
    export PATH=/sbin:$PATH
    export PATH=/bin:$PATH
    export PATH=${ZSHRCDIR}/local/bin:$PATH

	# 補完機能強化
	autoload -U compinit
	compinit

	# 正規表現強化
	setopt EXTENDED_GLOB

	# ディレクトリ名のみで移動可能にする
	setopt auto_cd

	# 移動したディレクトリを記録
	setopt auto_pushd

	# historyの設定
	HISTFILE=$HOME/.zsh/.histfile
	HISTSIZE=10000
	SAVEHIST=10000
	setopt extended_history
	setopt append_history
	setopt hist_no_store
	setopt hist_ignore_dups
# }}}

# エイリアス{{{1
       alias vi="vim" 
# }}}

# 外部ファイルの読み込み{{{1
	load_file_if_exists "$ZSH/oh-my-zsh.sh"
# }}}

# Github api token for Homebrew
export HOMEBREW_GITHUB_API_TOKEN=600d6125e44b1fcfdfc4adc3f38a588c0eefbce1

# rbenv
export PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}
eval "$(rbenv init - zsh)"

# phpenv
export PATH=${HOME}/.phpenv/bin:${HOME}/.phpenv/shims:${PATH}
eval "$(phpenv init - zsh)"

TERM=xterm
