" Should be copied or symlinked to ~/.config/nvim/init.vim

syntax on
set termguicolors

set number
set relativenumber

filetype plugin indent on

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
