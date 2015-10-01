#!/bin/sh

set -e
PREFIX=${HOME}/local
BINDIR=${PREFIX}/bin
LIBDIR=${PREFIX}/lib
INCLUDEDIR=${PREFIX}/include
LOGDIR=${PREFIX}/log
LOGFILE=${LOGDIR}/setup_`date +%m%d%H%M%S`.log

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
    brew install cmigemo
    brew install coreutils
    brew install docker
    brew install git --without-completions # source: https://github.com/robbyrussell/oh-my-zsh/issues/2394
    brew install gnu-sed
    brew install gnupg
    brew install go
    brew install heroku-toolbelt
    brew install hub
    brew install imagemagick
    brew install jq
    brew install jsl
    brew install kindlegen
    brew install lv
    brew install markdown
    brew install mercurial
    brew install nginx
    brew install npm
    brew install packer
    brew install phantomjs
    brew install pkg-config
    brew install postgresql
    brew install rbenv
    brew install readline
    brew install redis
    brew install ruby-build
    brew install stunnel
    brew install terminal-notifier
    brew install tig
    brew install tree
    brew install unrar
    brew install w3m
    brew install webkit2png
    brew install wget
    brew install xz
    brew install z

    # package name source: https://github.com/caskroom/homebrew-cask/tree/master/Casks
    # install where ~/Applications directory
    brew install caskroom/cask/brew-cask
    brew cask install appcleaner
    brew cask install atom
    brew cask install caffeine
    brew cask install dropbox
    brew cask install firefox
    brew cask install github
    brew cask install github-desktop
    brew cask install gyazo
    brew cask install kobito
    brew cask install licecap
    brew cask install lyn
    brew cask install sequel-pro
    brew cask install skype
    brew cask install sleipnir
    brew cask install sourcetree
    brew cask install vlc
    brew cask install paw
    brew cask install fluid
    brew cask install intellij-idea
    brew cask install macvim
    brew cask install iterm2
    brew cask install skitch
    brew cask install bartender
    brew cask install alfred
    brew cask install bettertouchtool
    brew cask install gimp
    brew cask install libreoffice
    brew cask install dash
    brew cask install disk-inventory-x
    # install where /Applications directory
    brew cask install google-cloud-sdk
    brew cask install flash
    brew cask install java
    brew cask install xquartz
    brew cask install google-japanese-ime
    brew cask install silverlight
    brew cask install vagrant
    # install where /Applications directory and need to create symlink to ~/Applications directory
    brew cask install karabiner && ln -s /Applications/Karabiner.app ~/Applications/ || true
    brew cask install virtualbox && ln -s /Applications/VirtualBox.app ~/Applications/ || true
    brew cask install totalfinder && ln -s /Applications/TotalFinder.app ~/Applications/ || true
    brew cask install microsoft-office && ln -s /Applications/Microsoft\ Office\ 2011 ~/Applications/ || true
    brew cask install justinmind && ln -s /Applications/Justinmind.app ~/Applications/ || true
    # need to appointed installing directory
    brew cask install google-chrome --caskroom='/Applications'
    brew cask install istat-menus --caskroom='/Applications'
    # create symlink to ~/Applications directory from /Applications directory
    ln -s /Applications/Utilities ~/Applications/ || true

    cat << EOF
Please manually install to these package by iTunes
・Xcode
・Airmail2
・Sunrize
・Slack
・Pocket
・1Password
・LINE
・ReadKit
・TweedDeck by Twitter
・Pixelmator
・MARKETSPEED
・iMage Tools
・MarsEdit
・Readkit
・StuffIt Expander
・Transmit
・Pushbullet
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
