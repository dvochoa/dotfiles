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

-- Show error messages inline
vim.diagnostic.config({
  virtual_text = true,
})

-- TODO: Uncomment this?
-- LSP keybindings (applied when LSP attaches to a buffer)
-- Note: Neovim 0.11+ has built-in defaults like K, grn, gra, etc.
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     local opts = { buffer = ev.buf }
--
--     -- Additional keybindings (built-ins: K, grn, gra, ctrl-], gq)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)           -- Go to definition
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)          -- Go to declaration
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)           -- Find references
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)       -- Go to implementation
--     vim.keymap.set('n', '<leader>f', function()
--       vim.lsp.buf.format({ async = true })
--     end, opts)                                                         -- Format file
--   end,
-- })


-- TODO: Do I actually need this custom stuff?
-- Lua language server with special config for Neovim
-- lspconfig.lua_ls.setup({
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { 'vim' }
--       },
--       workspace = {
--         library = vim.api.nvim_get_runtime_file("", true),
--         checkThirdParty = false,
--       },
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- })
