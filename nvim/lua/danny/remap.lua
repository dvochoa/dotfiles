local which_key = require "which-key"
local builtin = require('telescope.builtin')
local nvimtree = require "nvim-tree.api"

local telescope_mappings = {
  {
    { "<leader>f", group = "Find" },
    { "<leader>ff", builtin.find_files, desc = "Find files" },
    { "<leader>fg", builtin.git_files, desc = "Find git files" },
    { "<leader>fl", builtin.live_grep, desc = "Live grep" },
    { "<leader>fb", function() builtin.buffers({sort_mru = true, ignore_current_buffer=true }) end, desc = "Find buffers" }
  },
}

which_key.add(telescope_mappings)

local mappings = {
  {
    { "<leader>e", nvimtree.tree.toggle, desc = "Toggle File Explorer" },
    { "Q", "<cmd>bd<CR>", desc = "Close buffer" },
    { "[b", "<cmd>bn<CR>", desc = "Next buffer"},
    { "]b", "<cmd>bp<CR>", desc = "Previous buffer"},
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

    { "<C-u>", "<C-u>zz", desc = "Move Half Page Up"},
    { "<C-d>", "<C-d>zz", desc = "Move Half Page Down"},
    { "{", "{zz", desc = "Move Paragraph Up"},
    { "}", "}zz", desc = "Move Paragraph Down"},
  },
}

which_key.add(visual_mappings)

local text_manipulation_mappings = {
  {
    { "n", "nzzzv", desc = "Search for the next occurance of the term"},
    { "N", "Nzzzv", desc = "Search for the previous occurance of the term"},


    { "<leader>p", "\"_dP", mode = "x", desc = "Paste without overriding register"},

    { "<leader>y", "\"+y", desc = "Yank to system clipboard"},
    { "<leader>y", "\"+y", mode = "v", desc = "Yank to system clipboard"},
    { "<leader>Y", "\"+Y", desc = "Yank from cursor to end of line to system clipboard"},
  }
}

which_key.add(text_manipulation_mappings)

-- Unbind arrow keys in normal mode to enforce hjkl for navigation
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

