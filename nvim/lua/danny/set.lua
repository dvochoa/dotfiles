vim.cmd.colorscheme("tokyonight") -- set colortheme 

vim.o.clipboard = 'unnamedplus' -- use system keyboard for yank
 
vim.o.number = true -- enable line numbers
vim.o.relativenumber = true -- enable relative line numbers
vim.o.tabstop = 4 -- number of spaces a tab takes up
vim.o.shiftwidth = 4 -- number of spaces for each indent
vim.o.expandtab = true -- convert tabs to spaces
vim.o.smartindent = true -- automatically indent new lines
vim.o.wrap = false -- disable line wrapping
vim.o.incsearch = true -- enable incremental search
vim.o.termguicolors = true -- enable 24-bit RGB colors

-- Enable syntax highlighting and filetype plugins
vim.cmd.syntax('on')
vim.cmd.filetype('plugin indent on')

-- Add .vim directories to runtime path
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')

-- Set packpath to match runtimepath
vim.o.packpath = vim.o.runtimepath

