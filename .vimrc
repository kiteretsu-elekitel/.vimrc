" vimshell
let g:VimShell_EnableInteractive = 1

set autoindent
set smartindent
set number
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab        "タブをスペースに変更
"if don't input bigcase, don't Know which bigcase and smallcase
set smartcase
syntax on
set display=lastline
set pumheight=10

"開いたファイルにディレクトリを移動する
"条件付け例 xmlファイルとsdocファイルのみ有効
"           ("au BufEnter *.xml,*.sdoc execute ":lcd " . expand("%:p:h")
:au BufEnter * execute ":lcd " . expand("%:p:h")

set showtabline=2    "tabを常に表示
set cursorline       "カレント行のハイライト
set ignorecase       "検索時に文字の大小を無視
set smartcase        "検索時、文字の大小が混在する場合は区別する
set backspace=indent,eol,start   "BSでインデントや改行を削除
set wildmenu         "コマンドライン補完
set formatoptions+=mM "折り返しの日本語対応
set clipboard=unnamed  "copy to clipboard yank characters
set imdisable       "disable auto IM switch"
let &t_ti .= "\e[22;0t"
let &t_te .= "\e[23;0t"

"show cursorline only current window{"
augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black
"}"


"colorscheme setteing"
colorscheme solarized
set background=dark

"keyMapping for plugins"
nnoremap <space> <Nop>

" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge

"ファイルを開いた時、前回の編集位置にカーソルを戻す
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

"カーソルを表示行で移動する。物理行移動は<C-n>,<C-p>
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up>   gk

"mymoveword.vim"
let g:MyMoveWord_JpSep = '　。、．，／！？「」'
let MyMoveWord_enable_WBE = 1
let MyMoveWord_stop_eol = 1

"javaシンタックス
let java_highlight_all=1      "基本シンタックス
let java_highlight_debug=1     "debug syntax
"let java_space_errors=1        "余分な空白に大して警告
let java_highlight_functions=1 "メソッドの宣言文とブレースのハイライト

"ファイルの出力先を指定
set directory=~/.vim/tmp    "スワップファイルの出力先
set backupdir=~/.vim/tmp    "バックアップファイルの出力先

"スクロールの余白確保
set scrolloff=5
"現在のモードを表示
set showmode
"カーソルが行をまたいで移動出来るようにする
set whichwrap=b,s,h,l,<,>,[,]
"コマンドをステータス行に表示
set showmode
set smartindent "新しい行を開始した時、新しい行のインデントを現在行と同じ量にする
set hlsearch    "検索文字をハイライト

"escの2回押しでハイライト消去
nnoremap<ESC><ESC> :nohlsearch<CR>

"set cmdheight=4 "コマンドウィンドウの行数
set title       " タイトルバーにパスを表示
set wildmenu    "コマンドラインモードでTabキーでファイル名補完有効
set showcmd     "入力中のコマンドを表示
set hlsearch    "検索結果をハイライト表示
set incsearch   "インクリメンタルサーチ有効











"//////////////////////////
"エンコード関連
"/////////////////
"
set encoding=utf-8  "デフォルトはユニコード
" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
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
" 日本語を含まない場合は fileencoding に encoding を使うようにする
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

" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932



"//////////////////////////////////////////////
"//
"//Neobundleの設定
"//
"//////////////////////////////////////////////

set nocompatible               " be iMproved
filetype off


if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'
  call neobundle#end()
endif
" originalrepos on github
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Townk/vim-autoclose'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'kakkyz81/evervim'
NeoBundle 'othree/html5.vim'
NeoBundle 'mattn/flappyvird-vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'spolu/dwm.vim'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'lilydjwg/colorizer'


""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

filetype plugin indent on     " required!
filetype indent on


"追加プラグイン
NeoBundle 'scrooloose/nerdtree'  "ファイルのツリー表示（:NERDTreeで表示



"------------------------------------
" unite.vim
"------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=0
let g:unite_source_history_yank_enable = 1
" バッファ一覧
"noremap <C-U><C-B> :Unite buffer<CR>
" ファイル一覧
"noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
" 最近使ったファイルの一覧
"noremap <C-U><C-R> :Unite file_mru<CR>
" レジスタ一覧
"noremap <C-U><C-Y> :Unite -buffer-name=register register<CR>
" ファイルとバッファ
"noremap <C-U><C-U> :Unite buffer file_mru<CR>
" 全部
"noremap <C-U><C-A> :Unite UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

"------------------------------------
"unite Key mappings"
"------------------------------------
nnoremap [unite] <Nap>
nmap <space>u [unite]

"unite function key
nmap <silent> [unite]h   :<C-u>Unite file_mru<CR>
nmap <silent> [unite]y   :<C-u>Unite history/yank<CR>
nmap <silent> [unite]f   :<C-u>Unite file<CR>
nmap <silent> [unite]d   :<C-u>Unite directory<CR>
nmap <silent> [unite]r   :<C-u>Unite register<CR>
nmap <silent> [unite]c   :<C-u>Unite -default-action=lcd directory_mru<CR>

"-------------------------------------
"EverVim settings
"-------------------------------------
"Evernote Developer Token
let g:evervim_devtoken='S=s27:U=2cc769:E=151d48d3ce1:C=14a7cdc0e20:P=1cd:A=en-devtoken:V=2:H=2da766db118e6d7a5956734ef55a3f53'

"Evernote Keys
nmap <space>e [Evervim]
nnoremap [Evervim] <Nap>

nmap <silent> [Evervim]l   :<C-u>EvervimNotebookList<CR>
nmap <silent> [Evervim]t   :<C-u>EvervimListTags<CR>
nmap <silent> [Evervim]n   :<C-u>EvervimCreateNote<CR>
nmap <silent> [Evervim]N   :<C-u>EvervimPageNext<CR>
nmap <silent> [Evervim]P   :<C-u>EvervimPagePrev<CR>


"------------------------------------
"Neocomplete
"------------------------------------
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
let g:neocomplete#lock_iminsert = 1

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }
let g:neocomplete#max_list = 10

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
inoremap <expr><C-Space>  neocomplete#close_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'



"------------------------------------
"dwm.vim
"------------------------------------
" dwm.vim 設定（全てデフォルト）
nnoremap <c-j> <c-w>w
nnoremap <c-k> <c-w>W
nmap <m-r> <Plug>DWMRotateCounterclockwise
nmap <m-t> <Plug>DWMRotateClockwise
nmap <c-n> <Plug>DWMNew
nmap <c-c> <Plug>DWMClose
nmap <c-@> <Plug>DWMFocus
nmap <c-Space> <Plug>DWMFocus
nmap <c-l> <Plug>DWMGrowMaster
nmap <c-h> <Plug>DWMShrinkMaster

let g:dwm_master_pane_width="66%"
