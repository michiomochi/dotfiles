" 変数定義 {{{1
let $VIMRCDIR=expand('<sfile>:h')
let $VIMRC=expand('<sfile>')
let $BACKUPDIR=$VIMRCDIR . '/.vim/backup'
" }}}
" プラグイン {{{1
" NeoBundleの設定 {{{2
" vi互換をoff
set nocompatible
" gitプロトコルではプロキシ環境下の場合プラグインをもってこれないのでhttpsプロトコルを使用する
let g:neobundle_default_git_protocol='https'
" ファイル形式の検出をoff
filetype off
" NeoBundleの設定
if has('vim_starting')
  set runtimepath+=$VIMRCDIR/.vim/bundle/neobundle.vim
  call neobundle#begin($VIMRCDIR . '/.vim/bundle/')
  NeoBundleFetch 'Shougo/neobundle.vim'
  call neobundle#end()
endif
" }}}
" NeoBundleでインストールするプラグインの一覧 {{{2
NeoBundle 'Shougo/vimshell'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'tpope/vim-surround'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'chase/vim-ansible-yaml'
" color scheme
NeoBundle 'tomasr/molokai'
" ディレクトリをサイドバーにツリー表示
NeoBundle 'scrooloose/nerdtree'
" インデントに色をつけ見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
" 行末の半角スペースを可視化
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundleLazy 'Shougo/neosnippet'
NeoBundleLazy 'Shougo/neosnippet-snippets'
if has('lua')
    NeoBundleLazy 'Shougo/neocomplete', {
                \   'depends' : ['Shougo/neosnippet', 'Shougo/neosnippet-snippets', 'Shougo/context_filetype.vim'],
                \   'vim_version' : '7.3.885',
                \   'autoload' : {
                \       'insert' : 1,
                \   }
                \}
else
    NeoBundleLazy 'Shougo/neocomplcache', {
                \   'depends' : ['Shougo/neosnippet', 'Shougo/neosnippet-snippets'],
                \   'autoload' : {
                \       'insert' : 1,
                \   }
                \}
endif
NeoBundleCheck
" }}}
" }}}
" 基本設定 {{{1
" swpファイルを作成しない
set noswapfile
" クリップボード設定
set clipboard=unnamed
" ファイル形式別のプラグイン、及びインデントを有効にする
filetype plugin indent on
" syntaxの有効化
syntax on
" modelineを有効にする
set modeline
" 3行目までをmodelineとして検索する
set modelines=3
" 行番号の表示
set number
" インサートモードを抜けたら日本語入力OFF
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" swpファイルの保存ディレクトリを設定
set directory=$VIMRCDIR/.vim/backup
" タブ表示幅
set tabstop=2
" タブ挿入幅
set shiftwidth=2
" タブの代わりにスペースを挿入する
set expandtab
" カーソル移動が行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]
" 自動コメントアウト挿入をオフ
augroup autoCommentOutOff
    autocmd!
    autocmd FileType * setlocal fo=cq
augroup END
" 上下を常時5行空ける
set scrolloff=5
" バックスペースで各種削除可能にする
set backspace=indent,eol,start
" マウス有効化
set mouse=a
" tmpファイルを編集するときはbackupを作成しない
" source: http://d.hatena.ne.jp/yuyarin/20100225/1267084794
set backupskip=/tmp/*,/private/tmp/*
" nerdtreeの設定
    " ファイル編集時自動で表示
    if !argc()
        autocmd vimenter * NERDTree|normal gg3j
    endif
    " 隠しファイルを表示
    let NERDTreeShowHidden = 1
    " ブックマークを表示
    let g:NERDTreeShowBookmarks=1 
    " ブックマークファイル作成ディレクトリを定義
    let NERDTreeBookmarksFile=$VIMRCDIR . '/.NERDTreeBookmarks'
" }}}
" キーマッピング {{{1
" noremap = 全モード
" vnoremap = Visualモード
" nnoremap = Normalモード
" cnoremap = Commandモード
" inoremap = Insertモード
" }}}
" 言語ごとの設定 {{{1
" PHP補完を有効化
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
autocmd FileType rb :set dictionary=~/.vim/dict/ruby.dict
" }}}
" 表示設定 {{{1
" colorSchemeの設定
set t_Co=256
colorscheme molokai
" }}}
" 先人の知恵 {{{1
" タブ機能をごきげんにする {{{2
" 参考: http://qiita.com/wadako111/items/755e753677dd72d8036d 
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示
" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>
" }}}
" unite.vimの設定 {{{2
NeoBundle 'Shougo/unite.vim'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
nnoremap <silent> ,uy :<C-u>Unite history/yank<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>
" }}}
" 文字コードの自動認識 {{{2
" source: http://www.kawaz.jp/pukiwiki/?vim#content_1_7
if &encoding !=# 'utf-8'
    set encoding=japan
    set fileencoding=japan
endif
if has('iconv')
    let s:enc_euc = 'euc-jp'
    let s:enc_jis = 'iso-2022-jp'
    " iconvがeucJP-msに対応しているかをチェック
    if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'eucjp-ms'
        let s:enc_jis = 'iso-2022-jp-3'
        " iconvがJISX0213に対応しているかをチェック
    elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
        let s:enc_euc = 'euc-jisx0213'
        let s:enc_jis = 'iso-2022-jp-3'
    endif
    " fileencodingsを構築
    if &encoding ==# 'utf-8'
        let s:fileencodings_default = &fileencodings
        let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
        let &fileencodings = &fileencodings .','. s:fileencodings_default
        unlet s:fileencodings_default
    else
        let &fileencodings = &fileencodings .','. s:enc_jis
        set fileencodings+=utf-8,ucs-2le,ucs-2
        if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
            set fileencodings+=cp932
            set fileencodings-=euc-jp
            set fileencodings-=euc-jisx0213
            set fileencodings-=eucjp-ms
            let &encoding = s:enc_euc
            let &fileencoding = s:enc_euc
        else
            let &fileencodings = &fileencodings .','. s:enc_euc
        endif
    endif
    " 定数を処分
    unlet s:enc_euc
    unlet s:enc_jis
endif
" 日本語を含まない場合はfileencodingにencodingを使うようにする
if has('autocmd')
    function! AU_ReCheck_FENC()
        if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
            let &fileencoding=&encoding
        endif
    endfunction
    autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
    set ambiwidth=double
endif
" }}}
" ステータスライン表示 {{{2
" source: http://qiita.com/joker1007/items/9dc7f2a92cfb245ad502
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%y%{tagbar#currenttag('[%s]','')}%{fugitive#statusline()}%{SyntasticStatuslineFlag()}%{exists('*SkkGetModeStr')?SkkGetModeStr():''}%=%l/%L,%c%V%8P\ 
set noshowmode
set wildmenu
set cmdheight=2
set wildmode=list:full
set showcmd
" }}}
" 検索設定 {{{2
set incsearch
set hlsearch
set ignorecase
set smartcase
set wrapscan
nohlsearch "reset highlight
nnoremap <silent> [space]/ :noh<CR>
map * <Plug>(visualstar-*)N
map # <Plug>(visualstar-#)N
" }}}
" 富豪的バックアップ {{{2
" source: http://swimmingpython.net/blog/?p=127
set backup
set backupdir=$BACKUPDIR
autocmd BufWritePre,FileWritePre,FileAppendPre * call UpdateBackupFile()
function! UpdateBackupFile()
    let dir = strftime($BACKUPDIR . '/%Y%m/%d', localtime())
    if !isdirectory(dir)
        let retval = system('mkdir -p -m 777 ' . dir)
    endif
    exe "set backupdir=".dir
    let time = strftime("%H_%M_%S", localtime())
    exe "set backupext=.".time
endfunction
" }}}
" }}}
" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0
