vim.cmd.colorscheme("tokyonight") -- set colortheme 

vim.opt.clipboard = 'unnamedplus' -- use system keyboard for yank
vim.opt.number = true -- enable line numbers
vim.opt.relativenumber = true -- enable relative line numbers
vim.opt.tabstop = 4 -- number of spaces a tab takes up
vim.opt.shiftwidth = 4 -- number of spaces for each indent
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- automatically indent new lines
vim.opt.wrap = false -- disable line wrapping
vim.opt.incsearch = true -- enable incremental search
vim.opt.termguicolors = true -- enable 24-bit RGB colors

-- Enable syntax highlighting and filetype plugins
vim.cmd.syntax('on')
vim.cmd.filetype('plugin indent on')

-- Add .vim directories to runtime path
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')

-- Set packpath to match runtimepath
vim.o.packpath = vim.o.runtimepath

