-- Scala LSP. Metals is managed by nvim-metals, not mason/lspconfig.
-- Install/update the server with :MetalsInstall / :MetalsUpdate (needs coursier).
return {
  "scalameta/nvim-metals",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "scala", "sbt" }, -- java stays on jdtls
  config = function()
    local metals_config = require("metals").bare_config()
    -- Metals 1.4+ needs Java 17+ to run (JAVA_HOME picks that JVM), while
    -- javaHome is the project JDK; keep it matching sbt's or Metals nags to restart BSP.
    metals_config.cmd_env = { JAVA_HOME = vim.fn.expand("~/.sdkman/candidates/java/21.0.8-tem") }
    metals_config.settings = {
      javaHome = vim.fn.expand("~/.sdkman/candidates/java/11.0.23-tem"),
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      automaticImportBuild = "all",
      defaultBspToBuildTool = true,
      showImplicitArguments = true,
      showImplicitConversionsAndClasses = true,
      showInferredType = true,
    }
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt" },
      group = vim.api.nvim_create_augroup("nvim-metals", { clear = true }),
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
    })
  end,
}
