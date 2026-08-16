set laststatus=2
set nu rnu
set virtualedit=onemore
set whichwrap=<,>,[,],h,l
set backspace=indent,eol,start
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set belloff=all
set hid
set nobackup
set nowb
set hlsearch
set incsearch
set wildmenu
" set autochdir
set linebreak
set ignorecase
set smartcase
set autoread
syntax enable
command Config :e ~/.vimrc
command Ord :e ~/Projects/uhw3/fall2026
command MD :set filetype=markdown
au InsertEnter * :set norelativenumber
au InsertLeave * :set rnu | :normal! `^
" nnoremap <c-v> "*P
" inoremap <c-v> <esc>"*pi
nnoremap <space>b :BuffergatorOpen <CR>
nnoremap <c-d> :bdelete
nnoremap <space>f :FZF <CR>
nnoremap <s-u> :redo<CR>
nnoremap <c-\> :vsplit<CR>
" noremap <c-c> "*y
call plug#begin()
Plug 'tpope/vim-vinegar'
Plug 'thedenisnikulin/vim-cyberpunk'
Plug 'pgdouyon/vim-yin-yang'
Plug 'ronwoch/hotline-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'panozzaj/print_wb'
Plug 'mattn/emmet-vim'
Plug 'mnishz/colorscheme-preview.vim'
" Plug 'wfxr/minimap.vim'
" ^ for the above: nix-shell -p code-minimap
" Plug 'majutsushi/tagbar'
Plug 'ervandew/supertab'
" Plug 'severin-lemaignan/vim-minimap'
call plug#end()

colorscheme hotline
set notermguicolors

" colorscheme cyberpunk
" set termguicolors

let g:airline_theme='lucius'
let g:netrw_keepdir= 0 
let g:minimap_width = 10
"let g:tagbar_ctags_bin='~/Downloads/ctags/ctags.exe'


