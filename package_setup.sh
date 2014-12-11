#!/bin/sh

set -e
PREFIX=${HOME}/local
BINDIR=${PREFIX}/bin
LIBDIR=${PREFIX}/lib
INCLUDEDIR=${PREFIX}/include
LOGDIR=${PREFIX}/log
LOGFILE=${LOGDIR}/setup_`date +%m%d%H%M%S`.log

export PATH=${BINDIR}:${PATH}
export LD_LIBRARY_PATH=${LIBDIR}:${LD_LIBRARY_PATH}

function git_install() {
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
    make install > ${LOGFILE} 2>&1 | return 1
    echo 'gitがインストールされました'
}

function error_catch() {
    echo 'エラーが発生しました。log/setup*.logを確認してください。'
    exit 1
}

git_install || error_catch
