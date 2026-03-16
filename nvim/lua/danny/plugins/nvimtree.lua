return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    -- The file icons require a patched font (https://www.nerdfonts.com/ -- I use "Hack Nerd Font")
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local api = require("nvim-tree.api")

    local function on_attach(bufnr)
      -- Load all default mappings first
      api.config.mappings.default_on_attach(bufnr)

      -- Open file but return focus to nvim-tree when pressing "o"
      vim.keymap.set("n", "o", function()
        api.node.open.edit()
        api.tree.focus()
      end, { buffer = bufnr, noremap = true, silent = true, desc = "Open file, keep focus in tree" })
    end

    require("nvim-tree").setup(
      {
        on_attach = on_attach,
        view = {
          -- Width of File Explorer expands to fit content
          adaptive_size = true,
          width = {
            max = 50,  -- Maximum width in columns
          },
        },
        renderer = {
          highlight_git = true,
        },
        filters = {
          git_ignored = false,
          -- Ignore these files/directories
          custom = {"^\\.git$"},
        },
        update_focused_file = {
          -- Automatically navigate to the currently opened file
          enable = true,
          ignore_list = { "node_modules" },
        }
      }
    )

    -- Open on nvim start
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        -- Only open if no file was specified
        if data.file == "" and vim.fn.argc() == 0 then
          require("nvim-tree.api").tree.open()
          -- Close the empty [No Name] buffer
          vim.cmd("bdelete 1")
        end
      end
    })
  end
}
