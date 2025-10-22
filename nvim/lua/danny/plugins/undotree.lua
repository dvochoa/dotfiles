return {
  'mbbill/undotree',

  -- Runs after plugin loads
  config = function()
    -- Optional: Add keybinding to toggle undotree
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
  end
}

