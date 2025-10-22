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
    require('bufferline').setup {}
  end
}
