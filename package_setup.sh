#!/bin/sh

set -e
PREFIX=${HOME}/local
BINDIR=${PREFIX}/bin
LIBDIR=${PREFIX}/lib
INCLUDEDIR=${PREFIX}/include
LOGDIR=${PREFIX}/log
LOGFILE=${LOGDIR}/setup_`date +%m%d%H%M%S`.log

# for go
mkdir ${HOME}/.go
export GOPATH=${HOME}/.go
export PATH=${GOPATH}/bin:${HOME}

case "${OSTYPE}" in
darwin*)
    echo 'brew updating...'
    brew update
    outdated=$(brew outdated)
    if [ -n "${outdated}" ]; then
        cat << EOF

The following package(s) will upgrade.

$outdated

Are you sure?
If you do not want to upgrade, please type Ctrl-c now.
EOF
    read dummy
    brew upgrade
    fi

    brew tap homebrew/binary

    brew install ack
    brew install ag
    brew install ansible
    brew install aspell
    brew install autoconf
    brew install binutils
    brew install boot2docker
    brew install cmake
    brew install coreutils
    brew install ctags
    brew install direnv
    brew install docker
    brew install envchain
    brew install git --without-completions # source: https://github.com/robbyrussell/oh-my-zsh/issues/2394
    brew install gnu-sed
    brew install gnupg
    brew install go
    brew install heroku-toolbelt
    brew install hub
    brew install icu4c
    brew install imagemagick
    brew install jq
    brew install jsl
    brew install kindlegen
    brew install libxml2
    brew install libxslt
    brew install markdown
    brew install mercurial
    brew install mysql
    brew install ngrok
    brew install npm
    brew install packer
    brew install peco
    brew install phantomjs
    brew install pkg-config
    brew install postgresql
    brew install rbenv
    brew install readline
    brew install redis
    brew install ruby-build
    brew install terminal-notifier
    brew install tig
    brew install tmux
    brew install tree
    brew install unrar
    brew install w3m
    brew install webkit2png
    brew install wget
    brew install xz
    brew install z

    sudo easy_install pip
    sudo pip install awscli --ignore-installed six

    cat << EOF
Please manually install to these package
_appcleaner
_caffeine
_dropbox
_firefox
_licecap
_skype
_vlc
_paw
_fluid
_terraform
_macvim
_iterm2
_skitch
_bartender
_alfred
_bettertouchtool
_libreoffice
_dash
_disk-inventory-x
_flash
_java
_xquartz
_google-japanese-ime
_vagrant
_karabiner
_virtualbox
_google-chrome
_istat-menus

Please manually install to these package by Appstore
・1Password
・Airmail2
・iMage Tools
・LINE
・Monosnap
・Pixelmator
・Pushbullet
・Quiver
・TweedDeck by Twitter
・Slack
・Sunrize
・StuffIt Expander
・Xcode
EOF
    ;;
linux*)
    export PATH=${BINDIR}:${PATH}
    export LD_LIBRARY_PATH=${LIBDIR}:${LD_LIBRARY_PATH}

    # git 2.2.0 dependencies this package
    # curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker
    function git_install() {
        if [ -f ${BINDIR}/git ]; then
            echo '既にgitはインストールされています'
            return 0
        fi
        echo 'gitのインストールを開始します'
        cd ${PREFIX}/src
        if [ ! -f git-2.2.0.tar.gz ]; then
            echo 'git-2.2.0.tar.gzをダウンロードします'
            wget https://www.kernel.org/pub/software/scm/git/git-2.2.0.tar.gz > ${LOGFILE} 2>&1 || return 1
            tar xvf git-2.2.0.tar.gz > ${LOGFILE} 2>&1 || return 1
        fi
        cd git-2.2.0
        echo 'gitをコンパイル、インストールします'
        env LDFLAGS=-L${PREFIX}/lib CPPFLAGS=-I${PREFIX}/include ./configure --prefix=${PREFIX} > ${LOGFILE} 2>&1 || return 1
        make -j2 > ${LOGFILE} 2>&1 || return 1
        make install > ${LOGFILE} 2>&1 || return 1
        echo 'gitがインストールされました'
    }

    # vim 7.4 dependencies this package
    # lua perl-ExtUtils-Embed perl python ruby
    function vim_install() {
        if [ -f ${BINDIR}/vim ]; then
            echo '既にvimはインストールされています'
            return 0
        fi
        version='7.4'
        echo "vim${version}のインストールを開始します"
        cd ${PREFIX}/src
        if [ ! -f "vim-${version}.tar.bz2" ]; then
            echo "vim-${version}.tar.bz2をダウンロードします"
            wget http://ftp.vim.org/pub/vim/unix/vim-${version}.tar.bz2 > ${LOGFILE} 2>&1 || return 1
            tar xvf vim-${version}.tar.bz2 > ${LOGFILE} 2>&1 || return 1
        fi
        cd vim74
        ./configure --prefix=${HOME}/local \
                    --enable-multibyte \
                    --enable-perlinterp=yes \
                    --enable-pythoninterp=yes \
                    --enable-python3interp=yes \
                    --enable-rubyinterp=yes \
                    --disable-selinux \
                    --with-features=huge \
                    --enable-multibyte=yes \
                    --enable-luainterp=yes > ${LOGFILE} 2>&1 || return 1
        make -j2 > ${LOGFILE} 2>&1 || return 1
        make install > ${LOGFILE} 2>&1 || return 1
        echo "vim${version}がインストールされました"
    }

    function error_catch() {
        echo 'エラーが発生しました。log/setup*.logを確認してください。'
        exit 1
    }

    git_install || error_catch
    vim_install || error_catch
    ;;
esac

echo 'Package setup done!'
