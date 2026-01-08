return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    -- The file icons require a patched font (https://www.nerdfonts.com/ -- I use "Hack Nerd Font")
    'nvim-tree/nvim-web-devicons',
    'folke/tokyonight.nvim',
  },
  config = function()
    vim.cmd.colorscheme("tokyonight")
    vim.opt.termguicolors = true
    vim.opt.mousemoveevent = true
    require('bufferline').setup {
      options = {
        numbers = "ordinal",
        -- Should the tab close icon after hover
        hover = {
          enabled = true,
          delay = 100,
          reveal = {'close'}
        },
        offsets = {
          -- Adjust position when NvimTree is open
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true
          }
        }
      }
    }
  end
}
