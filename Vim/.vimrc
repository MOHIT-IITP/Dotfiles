set mouse=a
syntax on
set hlsearch
set ignorecase
set smartcase
set expandtab
set smartindent
set encoding=utf-8
filetype indent plugin on
set showmatch
filetype plugin indent on
let mapleader = " "
set relativenumber

set tabstop=2
set shiftwidth=2



nmap <leader>c ggVG"+y''
nnoremap <leader>r :w<CR>:! printf "Mohiittt your output is\n***********************\n" && g++ -std=c++1z -o test %:r.cpp && ./test && printf "*************************\n"<CR>
nnoremap <leader>f :w<CR>:! printf "Mohiiiitttttt your output from file is\n*************\n" &&  g++ -std=c++1z -o test %:r.cpp && ./test < input.txt && printf "*************\n"<CR>
nnoremap <leader>t :w<CR>:! printf "Mohitttt your time of execution file is\n*************\n" &&  g++ -std=c++1z -o test %:r.cpp && time ./test < input.txt && printf "*************\n"<CR>
nnoremap <leader>q :w<CR>:! printf "Mohitttt your output is \n*****************************\n" && python3 %:r.py<CR>
nnoremap <leader>j :w<CR>:! printf "Mohitttt your output is \n*************\n" && node %:r.js<CR>


" Normal Mode Navigation 
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Terminal Navitgatioin
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" Config for the moving the line 
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Config for copying stuff in system clipboard
nnoremap <leader>Y "+Y
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

set updatetime=50

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv



call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf.vim'

call plug#end()

set background=dark
colorscheme gruvbox

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTree<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:user_emmet_mode='n'    "only enable normal mode functions.
let g:user_emmet_mode='inv'  "enable all functions, which is equal to
let g:user_emmet_mode='a'    "enable all function in all mode.

let g:fzf_vim = {}
