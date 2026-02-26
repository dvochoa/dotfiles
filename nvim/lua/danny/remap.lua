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

-- Smart buffer close that switches to next/prev buffer in list
local function smart_buffer_close()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({buflisted = 1})

  -- Find current buffer's index
  local current_index = nil
  for i, buf in ipairs(buffers) do
    if buf.bufnr == current_buf then
      current_index = i
      break
    end
  end

  -- If more than one buffer exists, switch to next (or prev if last)
  if #buffers > 1 and current_index then
    local target_index
    if current_index < #buffers then
      -- Not the last buffer, go to next
      target_index = current_index + 1
    else
      -- Last buffer, go to previous
      target_index = current_index - 1
    end
    vim.api.nvim_set_current_buf(buffers[target_index].bufnr)
  end

  -- Delete the original buffer
  vim.api.nvim_buf_delete(current_buf, { force = false })
end


local buffer_mappings = {
  {
    { "Q", smart_buffer_close, desc = "Close buffer" },
    { "bda", "<Cmd>%bd<CR>", desc = "Close all buffers" },
    { "]b", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer"},
    { "[b", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer"},
    { "<leader>bp", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer in bufferline left"},
    { "<leader>bn", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer in bufferline right"}
  }
}

-- Jump to Nth buffer by index
local function goto_buffer_by_index(index)
  local buffers = vim.fn.getbufinfo({buflisted = 1})
  if buffers[index] then
    vim.api.nvim_set_current_buf(buffers[index].bufnr)
  end
end

-- Add mappings for jumping to buffers 1-9 by index
for i = 1, 9 do
  table.insert(
    buffer_mappings[1], { "<leader>" .. i, function() goto_buffer_by_index(i) end, desc = "Go to buffer " .. i }
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

    { "gg", "ggzz", desc = "Move to top of file"},
    { "G", "Gzz", desc = "Move to end of file"},
  },
}

which_key.add(visual_mappings)

local text_manipulation_mappings = {
  {
    { "n", "nzzzv", desc = "Search for the next occurance of the term"},
    { "N", "Nzzzv", desc = "Search for the previous occurance of the term"},
    { "*", "*zzzv", desc = "Search forward for word under cursor"},
    { "#", "#zzzv", desc = "Search backward for word under cursor"},
    { "<Esc><Esc>", "<Cmd>noh<CR>", desc = "Clear search highlighting"},

    { "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", desc = "Search and replace word under cursor"},

    { "<leader>p", "\"_dP", mode = "x", desc = "Paste without overriding register"},

    { "<leader>y", "\"+y", desc = "Yank to system clipboard"},
    { "<leader>y", "\"+y", mode = "v", desc = "Yank to system clipboard"},
    { "<leader>Y", "\"+Y", desc = "Yank from cursor to end of line to system clipboard"},
  }
}

which_key.add(text_manipulation_mappings)

-- Smart quickfix close that returns focus to a normal buffer (not nvim-tree)
local function smart_quickfix_close()
  -- Find the first normal buffer window (not special buffers like nvim-tree)
  local target_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.bo[buf].buftype
    local filetype = vim.bo[buf].filetype

    -- Skip quickfix, nvim-tree, and other special windows
    if buftype == "" and filetype ~= "NvimTree" then
      target_win = win
      break
    end
  end

  -- Close quickfix
  vim.cmd("cclose")

  -- Return focus to normal buffer if found
  if target_win then
    vim.api.nvim_set_current_win(target_win)
  end
end

local quickfix_mappings = {
  {
    { "<leader>q", group = "Quickfix" },
    { "<leader>qo", "<Cmd>copen<CR>", desc = "Open quickfix list" },
    { "<leader>qc", smart_quickfix_close, desc = "Close quickfix list" },
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

