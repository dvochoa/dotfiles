return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()

    -- Ctrl+_ for commenting
    local api = require('Comment.api')
    vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)
    vim.keymap.set('i', '<C-_>', api.toggle.linewise.current)
    vim.keymap.set('v', '<C-_>', function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
      api.toggle.linewise(vim.fn.visualmode())
    end)
  end
}

