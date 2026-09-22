return {
  'numToStr/Comment.nvim',
  dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  config = function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })

    -- Ctrl+/ & Ctrl+_ for commenting
    -- Prefer Ctrl+/ but include Ctrl+_ for environments without Kitty keyboard protocol support
    local api = require('Comment.api')
    for _, key in ipairs({ '<C-/>', '<C-_>' }) do
      vim.keymap.set('n', key, api.toggle.linewise.current)
      vim.keymap.set('i', key, api.toggle.linewise.current)
      vim.keymap.set('v', key, function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
      end)
    end
  end
}
