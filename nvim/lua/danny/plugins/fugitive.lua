return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', '<cmd>Git<CR>', { desc = 'Open Fugitive' })
    vim.keymap.set('n', '<leader>gB', '<cmd>Git blame<CR>', { desc = 'Blame file' })
  end,
}
