local which_key = require "which-key"
local builtin = require('telescope.builtin')

local telescope_mappings = {
  {
    { "<leader>f", group = "Find" },
    { "<leader>ff", builtin.find_files, desc = "Find files" },
    { "<leader>fg", builtin.git_files, desc = "Find git files" },
    { "<leader>fl", builtin.live_grep, desc = "Live grep" },
  },
}

which_key.add(telescope_mappings)

local mappings = {
  {
    { "<leader>e", vim.cmd.Ex, desc = "Open File Explorer" },
    { "Q", "<cmd>bd<CR>", desc = "Close buffer" },
    { "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", desc = "Search and replace word under cursor"},
  },
}

which_key.add(mappings)

local visual_mappings = {
  {
    { "J", ":m .+1<CR>==", desc = "Shift text up"},
    { "K", ":m .-2<CR>==", desc = "Shift text down"},
    { "J", ":m '>+1<CR>gv=gv", mode = "v", desc = "Shift text up"},
    { "K", ":m '<-2<CR>gv=gv", mode = "v", desc = "Shift text down"},

    { "<Tab>", ">>", desc = "Indent"},
    { "<S-Tab>", "<<", desc = "Reverse indent"},
    { "<Tab>", ">gv", mode = "v", desc = "Indent"},
    { "<S-Tab>", "<gv", mode = "v", desc = "Reverse indent"},
    { "<S-Tab>", "<C-d>", mode = "i", desc = "Reverse indent"},
  },
}

which_key.add(visual_mappings)

-- Unbind arrow keys in normal mode to enforce hjkl for navigation
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

