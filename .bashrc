#! /bin/bash

# 重複したPATHを削除する
function remove_duplicate_path(){
    eval "export PATH=$(perl -e '        #\
        my $e = shift;                   #\
        for(split q/:/, $ENV{"PATH"}){   #\
            if("$_" ne ""){              #\
                $n{$_} or $n{$_} = ++$i; #\
            }                            $\
        }                                #\
        $, = q/:/;                       #\
        %n = reverse %n;                 #\
        print map { $n{$_} }             #\
        sort { $a <=> $b } keys %n       #\
    ')"
}

# .bashrcがあるディレクトリのパスを取得する
# source: http://qiita.com/yudoufu/items/48cb6fb71e5b498b2532
BASHRCDIR=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

# .bashrc.localの読み込み
if [ -f ${BASHRCDIR}/.bashrc.local ]; then
    source ${BASHRCDIR}/.bashrc.local
fi

# PATHの設定
export PATH=/usr/local/sbin:${PATH}
export PATH=/usr/local/bin:${PATH}
export PATH=/usr/sbin:${PATH}
export PATH=/usr/bin:${PATH}
export PATH=/sbin:${PATH}
export PATH=/bin:${PATH}
export PATH=${BASHRCDIR}/local/bin:${PATH}
remove_duplicate_path

# プロンプト設定
export PS1="[\u@\H \w]\\$ "

# 使用エディタを設定
export EDITOR=${BASHRCDIR}/local/bin/vim

# エイリアス
alias vim='vim -u ${BASHRCDIR}/.vimrc'
