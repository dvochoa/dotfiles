return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6', -- or, branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            -- Center view after selecting in insert mode
            ["<CR>"] = function(prompt_bufnr)
              actions.select_default(prompt_bufnr)
              vim.cmd('normal! zz')
            end,
          },
          n = {
            -- Center view after selecting in normal mode
            ["<CR>"] = function(prompt_bufnr)
              actions.select_default(prompt_bufnr)
              vim.cmd('normal! zz')
            end,
          },
        },
      },
    })
  end
}
