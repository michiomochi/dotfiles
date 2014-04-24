#!/bin/bash

set -e
PREFIX=${HOME}/local
BINDIR=${PREFIX}/bin
LIBDIR=${PREFIX}/lib
INCLUDEDIR=${PREFIX}/include
LOGDIR=${PREFIX}/log
LOGFILE=${LOGDIR}/setup_`date +%m%d%H%M%S`.log
DOT_FILES=(.zshrc .vimrc .bashrc .tmux.conf .gitconfig)
DOT_DIRECTORIES=(.vim .zsh)

export PATH=${BINDIR}:${PATH}
export LD_LIBRARY_PATH=${LIBDIR}:${LD_LIBRARY_PATH}
# cpan初期設定を自動でデフォルト選択
export PERL_AUTOINSTALL='--defaultdeps'
# cpanでいれたライブラリディレクトリの指定
export PERL5LIB=/home/vagrant/local/lib/perl5/site_perl/5.18.0

function perl_install() {
	echo_install_start_message perl-5.18.0
	cd ${PREFIX}/src
	if [ ! -f perl-5.18.0.tar.gz ]; then
		wget_exec http://www.cpan.org/src/5.0/perl-5.18.0.tar.gz
		tar_exec perl-5.18.0.tar.gz
	fi
	cd perl-5.18.0
	echo_compile_start_message perl-5.18.0
	# 変数使うとprefixがうまく効かないので環境に応じて書き換える
	./configure.gnu -Dprefix=/home/vagrant/local >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message perl-5.18.0
}

function rbenv_install() {
	echo_install_start_message rbenv
	echo 'rbenvをgit cloneします'
	git clone https://github.com/sstephenson/rbenv.git ${HOME}/.rbenv >> ${LOGFILE} 2>&1 || return 1
	echo 'rbenvのgit cloneが完了しました'
	export PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}
	eval "$(rbenv init -)"
	# ruby-buildをrbenvのプラグインとしてインストール
	git clone https://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build >> ${LOGFILE} 2>&1 || return 1
	echo 'rbenvにruby-2.1.1をインストールします'
	# とりあえずruby2.1.1をいれて有効にしておく
	rbenv install 2.1.1 >> ${LOGFILE} 2>&1 || return 1
	rbenv global 2.1.1 >> ${LOGFILE} 2>&1 || return 1
	rbenv rehash >> ${LOGFILE} 2>&1 || return 1
	echo 'rbenvにruby-2.1.1をインストールしました'
	echo_install_complete_message rbenv
	echo '##### .bashrcに下記rbenvの設定をすること #####'
	echo 'export PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}'
	echo 'eval "$(rbenv init -)"'
}

function libtidy_install() {
	echo_install_start_message tidy-html5
	cd ${PREFIX}/src
	if [ ! -d tidy-html5 ]; then
		echo 'tidy-html5をgit cloneします'
		git clone https://github.com/w3c/tidy-html5.git >> ${LOGFILE} 2>&1 || return 1
		echo 'tidy-html5のgit cloneが完了しました'
	fi
	cd tidy-html5/build/gmake
	echo_compile_start_message tidy-html5
	make install runinst_prefix=${PREFIX} devinst_prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message tidy-html5	
}

function phpenv_install() {
	echo_install_start_message phpenv
	cd ${PREFIX}/src
	echo 'phpenvをgit cloneします'
	git clone https://github.com/CHH/phpenv.git >> ${LOGFILE} 2>&1 || return 1
	echo 'phpenvのgit cloneが完了しました'
	cd phpenv/bin	
	./phpenv-install.sh
	export PATH=${HOME}/.phpenv/bin:${HOME}/.phpenv/shims:${PATH}
	eval "$(phpenv init -)"
	# php-buildをphpenvのプラグインとしてインストール
	git clone https://github.com/CHH/php-build.git ${HOME}/.phpenv/plugins/php-build >> ${LOGFILE} 2>&1 || return 1
	echo 'phpenvにphp-5.5.11をインストールします'
	# とりあえずphp5.5.11をいれて有効にしておく
	sed -i '1s/^/configure_option "--with-libxml-dir=${HOME}\/local --with-curl=${HOME}\/local --with-jpeg-dir=${HOME}\/local --with-png-dir=${HOME}\/local --with-mcrypt=${HOME}\/local --with-tidy=${HOME}\/local --with-xsl=${HOME}\/local"\n/' ${HOME}/.phpenv/plugins/php-build/share/php-build/definitions/5.5.11
	phpenv install 5.5.11 >> ${LOGFILE} 2>&1 || return 1
	phpenv global 5.5.11 >> ${LOGFILE} 2>&1 || return 1
	phpenv rehash >> ${LOGFILE} 2>&1 || return 1
	echo 'phpenvにphp-5.5.11をインストールしました'
	echo_install_complete_message phpenv
	echo '##### .bashrcに下記rbenvの設定をすること #####'
	echo 'export PATH=${HOME}/.rbenv/bin:${HOME}/.rbenv/shims:${PATH}'
	echo 'eval "$(rbenv init -)"'
}

function libmcrypt_install() {
	echo_install_start_message libmcrypt-2.5.8.tar.gz
	cd ${PREFIX}/src
	if [ ! -f libmcrypt-2.5.8.tar.gz ]; then
		wget_exec http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
		tar_exec libmcrypt-2.5.8.tar.gz
	fi
	cd libmcrypt-2.5.8
	echo_compile_start_message libmcrypt-2.5.8
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libmcrypt-2.5.8
}

function libxml2_install() {
	echo_install_start_message libxml2-2.8.0
	cd ${PREFIX}/src
	if [ ! -f libxml2-2.8.0.tar.gz ]; then
		wget_exec http://xmlsoft.org/sources/libxml2-2.8.0.tar.gz
		tar_exec libxml2-2.8.0.tar.gz
	fi
	cd libxml2-2.8.0
	echo_compile_start_message libxml2-2.8.0
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libxml2-2.8.0
}

function libtool_install() {
	echo_install_start_message libtool-2.4.2
	cd ${PREFIX}/src
	if [ ! -f libtool-2.4.2.tar.gz ]; then
		wget_exec http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.gz
		tar_exec libtool-2.4.2.tar.gz
	fi
	cd libtool-2.4.2
	echo_compile_start_message libtool-2.4.2
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libtool-2.4.2	
}

function libjpeg_install() {
	echo_install_start_message libjpeg
	cd ${PREFIX}/src
	if [ ! -f jpegsrc.v6b.tar.gz ]; then
		wget_exec http://downloads.sourceforge.net/project/libjpeg/libjpeg/6b/jpegsrc.v6b.tar.gz
		tar_exec jpegsrc.v6b.tar.gz
	fi
	cd jpeg-6b
	echo_compile_start_message libjpeg
	./configure --prefix=${PREFIX} --enable-shared >> ${LOGFILE} 2>&1 || return 1
	make -j2 LIBTOOL=libtool >> ${LOGFILE} 2>&1 || return 1
	mkdir -p ${PREFIX}/man/man1
	make install LIBTOOL=libtool >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libjpeg
}

function libpng_install() {
	echo_install_start_message libpng-1.6.10
	cd ${PREFIX}/src
	if [ ! -f libpng-1.6.10.tar.gz ]; then
		wget_exec http://downloads.sourceforge.net/project/libpng/libpng16/1.6.10/libpng-1.6.10.tar.gz
		tar_exec libpng-1.6.10.tar.gz
	fi
	cd libpng-1.6.10
	echo_compile_start_message libpng-1.6.10
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libpng-1.6.10
}

function cpan_module_install() {
	# MakeMakerをいれる
	echo_install_start_message ExtUtils::MakeMaker
	cpan -i ExtUtils::MakeMaker >> ${LOGFILE} 2>&1
	echo_install_complete_message ExtUtils::MakeMaker

	# Installをいれる
	echo_install_start_message ExtUtils::Install
	cpan -i ExtUtils::Install >> ${LOGFILE} 2>&1
	echo_install_complete_message ExtUtils::Install
}

function curl_install() {
	echo 'curlのインストールを開始します'
	cd ${PREFIX}/src
	if [ ! -f curl-7.21.7.tar.bz2 ]; then
		echo 'curl-7.21.7.tar.bz2をダウンロードします'
		wget http://curl.haxx.se/download/curl-7.21.7.tar.bz2 >> ${LOGFILE} 2>&1 || return 1
		tar xvf curl-7.21.7.tar.bz2 >> ${LOGFILE} 2>&1 || return 1 
	fi
	cd curl-7.21.7
	echo 'curlをコンパイル、インストールします'
	./configure --prefix=${PREFIX} > ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo 'curlがインストールされました'
}

function libxslt_install() {
	echo_install_start_message libxslt-1.1.28.tar.gz
	cd ${PREFIX}/src
	if [ ! -f libxslt-1.1.28.tar.gz ]; then
		wget_exec ftp://xmlsoft.org/libxslt/libxslt-1.1.28.tar.gz
		tar_exec libxslt-1.1.28.tar.gz
	fi
	cd libxslt-1.1.28
	echo_compile_start_message libxslt-1.1.28
	./configure --prefix=${PREFIX} --with-libxml-prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libxslt-1.1.28
}

function gettext_install() {
	echo 'gettextのインストールを開始します'
	cd ${PREFIX}/src
	if [ ! -f gettext-0.18.3.1.tar.gz ]; then
		echo 'gettext-0.18.3.1.tar.gzをダウンロードします'
		wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.3.1.tar.gz > ${LOGFILE} 2>&1 || return 1
		tar xvf gettext-0.18.3.1.tar.gz > ${LOGFILE} 2>&1 || return 1
	fi
	cd gettext-0.18.3.1
	echo 'gettextをコンパイル、インストールします'
	./configure --prefix=${PREFIX} > ${LOGFILE} 2>&1 || return 1
	make -j2 > ${LOGFILE} 2>&1 || return 1
	make install > ${LOGFILE} 2>&1 | return 1
	echo 'gettextがインストールされました'
}

function git_install() {
	echo 'gitのインストールを開始します'
	cd ${PREFIX}/src
	if [ ! -f git-1.9.0.tar.gz ]; then
		echo 'git-1.9.0.tar.gzをダウンロードします'
		wget https://git-core.googlecode.com/files/git-1.9.0.tar.gz > ${LOGFILE} 2>&1 || return 1
		tar xvf git-1.9.0.tar.gz > ${LOGFILE} 2>&1 || return 1
	fi
	cd git-1.9.0
	echo 'gitをコンパイル、インストールします'
	env LDFLAGS=-L${PREFIX}/lib CPPFLAGS=-I${PREFIX}/include ./configure --prefix=${PREFIX} > ${LOGFILE} 2>&1 || return 1
	make -j2 > ${LOGFILE} 2>&1 || return 1
	make install > ${LOGFILE} 2>&1 | return 1
	echo 'gitがインストールされました'
}

function ag_install() {
	echo_install_start_message the_silver_searcher
	cd ${PREFIX}/src
	if [ ! -d the_siver_searcher ]; then
		echo 'the_silver_searcherをgit cloneします'
		# 本家はhttps://github.com/ggreer/the_silver_searcher.git
		# 本家はshift-jisやeuc-jpに対応していないためforkされたhttps://github.com/monochromegane/the_silver_searcherを使う
		# source: http://blog.monochromegane.com/blog/2013/09/15/the-silver-searcher-detects-japanese-char-set
		git clone https://github.com/monochromegane/the_silver_searcher.git >> ${LOGFILE} 2>&1 || return 1
		echo 'the_silver_searcherのgit cloneが完了しました'
	fi
	cd the_silver_searcher
	echo_compile_start_message the_silver_searcher
	./build.sh --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message the_silver_searcher
}

function autoconf_install() {
	echo_install_start_message autoconf-2.69
	cd ${PREFIX}/src
	if [ ! -f autoconf-2.69.tar.gz ]; then
		wget_exec http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
		tar_exec autoconf-2.69.tar.gz
	fi
	cd autoconf-2.69
	echo_compile_start_message autoconf-2.69
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message autoconf-2.69
}

function readline_install() {
	echo_install_start_message readline-6.3
	cd ${PREFIX}/src
	if [ ! -f readline-6.3.tar.gz ]; then
		wget_exec http://ftp.gnu.org/pub/gnu/readline/readline-6.3.tar.gz
		tar_exec readline-6.3.tar.gz
	fi
	cd readline-6.3
	echo_compile_start_message readline-6.3
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message readline-6.3
}

function lua_install() {
	echo_install_start_message lua-5.2.3
	cd ${PREFIX}/src
	if [ ! -f lua-5.2.3.tar.gz ]; then
		wget_exec http://www.lua.org/ftp/lua-5.2.3.tar.gz
		tar_exec lua-5.2.3.tar.gz
	fi
	cd lua-5.2.3
	echo_compile_start_message lua-5.2.3
    make linux MYLIBS="-L ${LIBDIR} -ltermcap" >> ${LOGFILE} 2>&1 || return 1
    make install INSTALL_TOP=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message lua-5.2.3
}

function vim_install() {
	echo_install_start_message vim-7.4
	cd ${PREFIX}/src
	if [ ! -f vim-7.4.tar.bz2 ]; then
		wget_exec http://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2
		tar_exec vim-7.4.tar.bz2
	fi
	cd vim74
	echo_compile_start_message vim-7.4
	./configure --prefix=${PREFIX} --with-features=huge --enable-multibyte=yes --enable-luainterp=yes --with-lua-prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message vim-7.4
}

function automake_install() {
	echo_install_start_message automake-1.14
	cd ${PREFIX}/src
	if [ ! -f automake-1.14.tar.gz ]; then
		wget_exec http://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz
		tar_exec automake-1.14.tar.gz
	fi
	cd automake-1.14
	echo_compile_start_message automake-1.14
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message automake-1.14
}

function pcre_install() {
	echo_install_start_message pcre-8.35
	cd ${PREFIX}/src
	if [ ! -f pcre-8.35.tar.bz2 ]; then
		wget_exec http://downloads.sourceforge.net/project/pcre/pcre/8.35/pcre-8.35.tar.bz2
		tar_exec pcre-8.35.tar.bz2
	fi
	cd pcre-8.35
	echo_compile_start_message pcre-8.35
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message pcre-8.35
}

function pkgconfig_install() {
	echo_install_start_message pkg-config-0.28
	cd ${PREFIX}/src
	if [ ! -f pkg-config-0.28.tar.gz ]; then
		wget_exec http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz
		tar_exec pkg-config-0.28.tar.gz
	fi
	cd pkg-config-0.28
	echo_compile_start_message pkg-config-0.28
	./configure --prefix=${PREFIX} --with-internal-glib GLIB_LIBS="-L${PREFIX}/lib" GLIB_CFLAGS="-I${PREFIX}/include/glib-2.0 -I${PREFIX}/lib/glib-2.0/include" >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message pkg-config-0.28	
}

function glib_install() {
	echo_install_start_message glib-2.40.0
	cd ${PREFIX}/src
	if [ ! -f glib-2.40.0.tar.xz ]; then
		wget_exec http://ftp.gnome.org/pub/GNOME/sources/glib/2.40/glib-2.40.0.tar.xz
		xz -dc glib-2.40.0.tar.xz | tar xvf - > /dev/null 2>&1
	fi
	cd glib-2.40.0
	echo_compile_start_message glib-2.40.0
	./configure --prefix=${PREFIX} LIBFFI_LIBS="-L${PREFIX}/lib64 -lffi" LIBFFI_CFLAGS="-I${PREFIX}/lib/libffi-3.0.13/include" >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message glib-2.40.0
}

function libffi_install() {
	echo_install_start_message libffi-3.0.13
	cd ${PREFIX}/src
	if [ ! -f libffi-3.0.13.tar.gz2 ]; then
		wget_exec ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz
		tar_exec libffi-3.0.13.tar.gz
	fi
	cd libffi-3.0.13
	echo_compile_start_message libffi-3.0.13
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message libffi-3.0.13
}

function xz_install {
	echo_install_start_message xz-5.0.5
	cd ${PREFIX}/src
	if [ ! -f xz-5.0.5.tar.bz2 ]; then
		wget_exec http://tukaani.org/xz/xz-5.0.5.tar.bz2
		tar_exec xz-5.0.5.tar.bz2
	fi
	cd xz-5.0.5
	echo_compile_start_message xz-5.0.5
	./configure --prefix=${PREFIX} >> ${LOGFILE} 2>&1 || return 1
	make -j2 >> ${LOGFILE} 2>&1 || return 1
	make install >> ${LOGFILE} 2>&1 || return 1
	echo_install_complete_message xz-5.0.5
}

function echo_install_start_message() {
	printf '%sのインストールを開始します\n' $1
}

function echo_compile_start_message() {
	printf '%sをコンパイル、インストールします\n' $1
}

function echo_install_complete_message() {
	printf '%sのインストールが完了しました\n' $1
}

function wget_exec() {
	printf '%sのダウンロードを開始します\n' $1
	wget $1 >> ${LOGFILE} 2>&1 || return 1
	printf '%sのダウンロードが完了しました\n' $1
}

function tar_exec() {
	tar xvf $1 >> ${LOGFILE} 2>&1 || return 1
}

function error_catch() {
	echo 'エラーが発生しました。log/setup*.logを確認してください。'
	exit 1
}

# ${LOGDIR}ディレクトリがなかったら作る
if [ ! -d ${LOGDIR} ]; then
	printf '%sディレクトリを作成します\n' ${LOGDIR}
	mkdir -p ${LOGDIR}
fi

# ${LOGFILR}をtouchする
if [ ! -f ${LOGFILE} ]; then
	printf '%sファイルを作成します\n' ${LOGFILE}
	touch ${LOGFILE}
else
	printf '%sファイルがすでに存在します。\n' ${LOGFILE}
	error_catch
fi

# ${PREFIX}/srcディレクトリがなかったら作る
if [ ! -d ${PREFIX}/src ]; then
	printf '%s/srcディレクトリを作成します\n' ${PREFIX}
	mkdir -p ${PREFIX}/src
fi

# xzをいれる
if [ ! -f ${BINDIR}/xz ]; then
	xz_install || error_catch
fi

# readlineをいれる
if [ ! -f ${INCLUDEDIR}/readline/readline.h ]; then
    readline_install || error_catch
fi

# luaをいれる
if [ ! -f ${BINDIR}/lua ]; then
    lua_install || error_catch
fi

# vimをいれる
if [ ! -f ${BINDIR}/vim ]; then
    vim_install || error_catch
fi

# msgfmtコマンドをいれる
if ! type msgfmt > /dev/null 2>&1; then
	gettext_install || error_catch
fi

# glibをいれる
# depends on libffi
if [ ! -f ${INCLUDEDIR}/glib-2.0/glib.h ]; then
	# libffiをいれる
	if [ ! -f ${LIBDIR}/libffi-3.0.13/include/ffi.h ]; then
		libffi_install || error_catch
	fi
	glib_install || error_catch
fi

# automakeをいれる
# depends on autoconf
if [ ! -f ${BINDIR}/automake ]; then
	# autoconfをいれる
	if [ ! -f ${BINDIR}/autoconf ]; then
		autoconf_install || error_catch
	fi
	automake_install || error_catch
fi

# pkg-configをいれる
# depends on glib
if [ ! -f ${BINDIR}/pkg-config ]; then
	pkgconfig_install || error_catch
fi

# libxml2をいれる
if [ ! -d ${INCLUDEDIR}/libxml2 ]; then
	libxml2_install || error_catch
fi

# perlをいれる
if [ ! -f ${BINDIR}/perl ]; then
	perl_install || error_catch
fi

# cpanモジュールをいれる
cpan_module_install || error_catch

# curlコマンドがなかったらいれる
if ! type curl > /dev/null 2>&1; then
	curl_install || error_catch
fi

# gitコマンドがなかったらいれる
if ! type git > /dev/null 2>&1; then
	git_install || error_catch
fi

# tidyをいれる
# depends on libxslt
if [ ! -f ${BINDIR}/tidy ]; then
	if [ ! -f ${BINDIR}/xsltproc ]; then
		libxslt_install || error_catch	
	fi
	libtidy_install || error_catch
fi

# rbenvをいれる
if [ ! -d ${HOME}/.rbenv ]; then
	rbenv_install || error_catch
fi

# libjpegをいれる
# depends on libtool
if [ ! -f ${INCLUDEDIR}/jpeglib.h ]; then
	if [ ! -f ${BINDIR}/libtool ]; then
		libtool_install || error_catch
	fi
	libjpeg_install || error_catch
fi

# phpenvをいれる
# dependson libxml2, curl, libjpeg, libpng, libmcrypt, tidy
if [ ! -d ${HOME}/.phpenv ]; then
	if [ ! -f ${INCLUDEDIR}/libpng16/png.h ]; then
		libpng_install || error_catch
	fi
	if [ ! -f ${INCLUDEDIR}/mcrypt.h ]; then
		libmcrypt_install || error_catch
	fi
	phpenv_install || error_catch
fi

# the silver searcherをいれる
# depends on automake, pcre, zlib, pkg-config
if [ ! -f ${BINDIR}/ag ]; then
	# pcreをいれる
	if [ ! -f ${INCLUDEDIR}/pcre.h ]; then
		pcre_install || error_catch
	fi
	ag_install || error_catch
fi

#############################################
# 設定ファイルの配置
#############################################
echo '設定ファイルをHOMEディレクトリに配置します'
# HOMEディレクトリに各設定ファイルのシムリンクを作成する
for file in ${DOT_FILES[@]}
do
	if [ ! -f ${HOME}/dotfiles/${file} ]; then
		continue
	fi 
	# シムリンク作成予定箇所に既にシムリンクが存在する場合は削除する
	if [ -L ${HOME}/${file} ]; then
		rm -f ${HOME}/${file}
	fi
	# シムリンク作成予定箇所にファイルが存在する場合は.backupディレクトリに移動する
	if [ -f ${HOME}/${file} ]; then
		if [ ! -d ${HOME}/.backup ]; then
			mkdir ${HOME}/.backup
		fi
		mv ${HOME}/${file} ${HOME}/.backup/
	fi
	ln -s ${HOME}/dotfiles/${file} ${HOME}/${file}
done

for directory in ${DOT_DIRECTORIES[@]}
do
	if [ ! -d ${HOME}/dotfiles/${directory} ]; then
		continue
	fi 
	# シムリンク作成予定箇所に既にシムリンクが存在する場合は削除する
	if [ -L ${HOME}/${directory} ]; then
		rm -f ${HOME}/${directory}
	fi
	# シムリンク作成予定箇所にディレクトリが存在する場合は.backupディレクトリに移動する
	if [ -d ${HOME}/${directory} ]; then
		if [ ! -d ${HOME}/.backup ]; then
			mkdir ${HOME}/.backup
		fi
		mv ${HOME}/${directory} ${HOME}/.backup/
	fi
	ln -s ${HOME}/dotfiles/${directory} ${HOME}/${directory}
done

# gitのsubmoduleを有効にする
echo 'gitのsubmoduleを有効にします'
cd ${HOME}/dotfiles
GIT_SSL_NO_VERIFY=1 git submodule init
GIT_SSL_NO_VERIFY=1 git submodule update

echo 'setup完了'
