filetype plugin indent on
command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

set hidden
set completeopt=longest,menuone

au FileType elixir set formatprg=mix\ format\ -

let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

let g:rustfmt_autosave = 1
let g:dot_http_env = 'dev-local'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

set number
set background=dark
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set go-=m
set go-=T
set go-=L
set go-=r
colors gruvbox

set nocompatible

set showcmd

" Set the title of the vim window
set title
set titlestring=%t\ \(%{expand(\"%:p:h:t\")}\)

" Turn on incremental search
set incsearch

" Turn on syntax highlighting
syn on

" Set file encodings correctly
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif


" allow backspacing over everything in insert mode
set bs=2

" always set autoindenting on
set ai

" Remember last position
set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


" keep 100 lines of command line history
set history=100

" show the cursor position all the time
set ruler

imap <D-u> <C-u>
imap <D-d> <C-d>
map <C-r> :DotHttp<CR>

vmap < <gv
vmap > >gv

nnoremap q <C-w>

set clipboard^=unnamedplus,unnamedplus

set expandtab
let g:vim_markdown_folding_disabled = 1
set conceallevel=2
let g:markdown_fenced_languages = ['python', 'javascript', 'html', 'css', 'bash=sh', 'json', 'xml', 'c', 'cpp', 'java', 'ruby', 'vim']
set list
set listchars=eol:↴,tab:▸\ 
set fileformats=unix
