return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {
    formatters_by_ft = {
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      -- "swift" runs `swift format` (Xcode 16+); "swift_format" wants a
      -- standalone swift-format binary that isn't on PATH.
      swift = { "swift" },
    },
    format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
  }
}
