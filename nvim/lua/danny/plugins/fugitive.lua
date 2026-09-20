return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('c', 'g<CR>', 'G<CR>', { desc = 'Open Fugitive' })
  end,
}
