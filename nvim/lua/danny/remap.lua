local which_key = require "which-key"
local builtin = require('telescope.builtin')
local nvimtree = require "nvim-tree.api"

local telescope_mappings = {
  {
    { "<leader>f", group = "Find" },
    { "<leader>ff", builtin.find_files, desc = "Find files" },
    { "<leader>fh", function() builtin.find_files({ hidden = true }) end, desc = "Find files (including hidden)" },
    { "<leader>fg", builtin.git_files, desc = "Find git files" },
    { "<leader>fl", builtin.live_grep, desc = "Live grep" },
    { "<leader>fb", function() builtin.buffers({sort_mru = true, ignore_current_buffer=true }) end, desc = "Find buffers" }
  },
}

which_key.add(telescope_mappings)

-- Smart buffer close that skips special buffers (NvimTree, etc.)
local function smart_buffer_close()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()

  -- Find a valid buffer to switch to (not the current one, loaded, and not a special buffer)
  local target_buf = nil
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf
       and vim.api.nvim_buf_is_loaded(buf)
       and vim.bo[buf].buflisted
       and vim.bo[buf].buftype == "" then
      target_buf = buf
      break
    end
  end

  -- If we found a valid buffer, switch to it before closing
  if target_buf then
    vim.api.nvim_set_current_buf(target_buf)
  end

  -- Delete the original buffer
  vim.api.nvim_buf_delete(current_buf, { force = false })
end

local buffer_mappings = {
  {
    { "Q", smart_buffer_close, desc = "Close buffer" },
    { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer"},
    { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer"},
    { "<leader>bp", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer in bufferline left"},
    { "<leader>bn", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer in bufferline right"}
  }
}

-- Add BufferLineGoToBuffer mappings for buffers 1-9
for i = 1, 9 do
  table.insert(
    buffer_mappings[1], { "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", desc = "Go to buffer " .. i }
  )
end

which_key.add(buffer_mappings)

local window_mappings = {
  {
    { "<leader>e", nvimtree.tree.toggle, desc = "Toggle File Explorer" },
    { "]w", "<C-w>l", desc = "Next window"},
    { "[w", "<C-w>h", desc = "Previous window"},
  },
}

which_key.add(window_mappings)

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

    { "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", desc = "Search and replace word under cursor"},

    { "<leader>p", "\"_dP", mode = "x", desc = "Paste without overriding register"},

    { "<leader>y", "\"+y", desc = "Yank to system clipboard"},
    { "<leader>y", "\"+y", mode = "v", desc = "Yank to system clipboard"},
    { "<leader>Y", "\"+Y", desc = "Yank from cursor to end of line to system clipboard"},
  }
}

which_key.add(text_manipulation_mappings)

local quickfix_mappings = {
  {
    { "<leader>q", group = "Quickfix" },
    { "<leader>qo", "<Cmd>copen<CR>", desc = "Open quickfix list" },
    { "<leader>qc", "<Cmd>cclose<CR>", desc = "Close quickfix list" },
    { "]q", "<Cmd>cnext<CR>", desc = "Next quickfix item" },
    { "[q", "<Cmd>cprev<CR>", desc = "Previous quickfix item" },
  }
}

which_key.add(quickfix_mappings)

-- Unbind arrow keys in normal mode to enforce hjkl for navigation
vim.keymap.set('n', '<Up>', '<Nop>')
vim.keymap.set('n', '<Down>', '<Nop>')
vim.keymap.set('n', '<Left>', '<Nop>')
vim.keymap.set('n', '<Right>', '<Nop>')

