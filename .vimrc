" プラグイン {{{1
" NeoBundleの設定 {{{2

" vi互換をoff
set nocompatible

" ファイル形式の検出をoff
filetype off

" NeoBundleの設定
if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#rc(expand('~/.vim/bundle/'))
endif

" }}}
" NeoBundleでインストールするプラグインの一覧 {{{2
" ex, NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimshell'
NeoBundle 'kana/vim-smartchr'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neocomplete.vim'
" }}}
" }}}
" 基本設定 {{{1

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
set directory=$HOME/.vim/backup

" backupファイルの保存ディレクトリを設定
set backupdir=$HOME/.vim/backup

" タブの代わりにスペースも挿入する
set expandtab

" カーソル移動が行頭、行末で止まらないようにする
set whichwrap=b,s,h,l,<,>,[,]

" }}}
" キーマッピング {{{1

" noremap = 全モード

" vnoremap = Visualモード

" nnoremap = Normalモード

" 高速移動
nnoremap H b
nnoremap J }
nnoremap K {
nnoremap L w

" cnoremap = Commandモード

" inoremap = Insertモード

" }}}
" 言語ごとの設定 {{{1
" PHP補完を有効化
autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict
" }}}
" 表示設定 {{{1

" colorSchemeの設定
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
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
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
" }}}
" modelineにてvimrc専用の設定を記述
" vim: foldmethod=marker
" vim: foldcolumn=3
" vim: foldlevel=0
