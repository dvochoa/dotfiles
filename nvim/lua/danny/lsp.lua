-- List of language servers to install and configure
local lsps = {
  'ts_ls',
  'html',
  'cssls',
  'tailwindcss',
  'eslint',
  'jsonls',
  'marksman',
  'sqlls',
  'pyright',
  'lua_ls',
  'gopls',
}

-- Mason is used to install LSPs
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = lsps,
})

-- Enable all of the lsps
vim.lsp.enable(lsps)

-- Get default cmp capabilities and extend with cmp_nvim_lsp
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

-- Set default capabilities for all LSPs
vim.lsp.config['*'] = {
  capabilities = capabilities,
}

-- Configure lua_ls with Neovim-specific settings
vim.lsp.config.lua_ls = {
  cmd = { 'lua-language-server' },
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Set up autocomplete
local cmp = require('cmp')

cmp.setup({
  -- Completion sources in order of priority
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
  -- Key mappings
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  -- Snippet engine
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!'}
      }
    }
  }),
  matching = { disallow_symbol_nonprefix_matching = false }
})

-- Use buffer source for '/' and '?' searches
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

vim.diagnostic.config({
  virtual_text = true, -- Show diagnositc messages inline
  severity_sort = true, -- Sort diagnostics by severity
})

-- TODO: Move these into remap.lua and use which_key?
-- LSP keybindings (applied when LSP attaches to a buffer)
-- Note: Neovim 0.11+ has built-in defaults like K, grn, gra, etc.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- Go to definition
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- Hover documentation
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- Go to declaration
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- Find references
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- Go to implementation
    vim.keymap.set('n', 'gn', vim.lsp.buf.rename, opts) -- Rename the current entity

    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts) -- Open vim code actions menu
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts) -- Open diagnostics menu
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts) -- Go to next diagnostics item
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts) -- Go to prev diagnostics item

    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts) -- Show method signature

    vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
    end, opts) -- Format file
  end,
})
