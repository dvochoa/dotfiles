return {
  'tpope/vim-fugitive',
  config = function()
    -- Optional: Add some useful keybindings for fugitive
    vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
  end
}

