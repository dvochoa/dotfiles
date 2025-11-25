vim.cmd.colorscheme("tokyonight") -- set colortheme 

vim.opt.mouse = 'a' -- enable mouse in all modes

-- vim.opt.clipboard = 'unnamedplus' -- use system keyboard for yank
vim.opt.number = true -- enable line numbers
vim.opt.relativenumber = true -- enable relative line numbers

vim.opt.tabstop = 2 -- number of spaces a tab takes up
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- number of spaces for each indent
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- automatically indent new lines

vim.opt.wrap = false -- disable line wrapping

vim.opt.incsearch = true -- enable incremental search

vim.opt.termguicolors = true -- enable 24-bit RGB colors

-- Enable syntax highlighting and filetype plugins
vim.cmd.syntax('on')
vim.cmd.filetype('plugin indent on')

-- Disable netrw, replaced with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Highlight copied content on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Hightlight selection on yank',
  group = vim.api.nvim_create_augroup('YankHighlight', {}),
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 } -- Show highlight for 100ms
  end,
  pattern = '*',
})

-- Add .vim directories to runtime path
vim.opt.runtimepath:prepend('~/.vim')
vim.opt.runtimepath:append('~/.vim/after')

-- Set packpath to match runtimepath
vim.o.packpath = vim.o.runtimepath

