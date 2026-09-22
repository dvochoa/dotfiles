return {
  'numToStr/Comment.nvim',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  config = function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })

    -- Ctrl+/ for commenting
    local api = require('Comment.api')
    vim.keymap.set('n', '<C-/>', api.toggle.linewise.current)
    vim.keymap.set('i', '<C-/>', api.toggle.linewise.current)
    vim.keymap.set('v', '<C-/>', function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
      api.toggle.linewise(vim.fn.visualmode())
    end)
  end
}
