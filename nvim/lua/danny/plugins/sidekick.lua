-- Auto-target context sends to the `claude` running in THIS window's cwd.
-- Sidekick derives a stable session id from (tool, cwd) via Session.sid().
-- So we compute the sid our cwd would produce, find the session that matches, and pin the send to it.
-- Falls back to the picker when no session matches (cwd changed, claude not running, etc).
local function send(opts)
  opts = opts or {}
  pcall(function()
    local Session = require("sidekick.cli.session")
    local want = Session.sid({ tool = "claude", cwd = vim.fn.getcwd(0) })
    for _, s in ipairs(Session.sessions()) do
      if s.sid == want then
        opts.filter = { session = s.id }
        return
      end
    end
  end)
  require("sidekick.cli").send(opts)
end

return {
  "folke/sidekick.nvim",
  opts = {
    -- NES (Tab-to-accept inline suggestions) disabled
    nes = { enabled = false },
    cli = {
      -- tmux backend stays ENABLED so sidekick can discover and attach to a coding CLI pane launched OUTSIDE nvim and
      -- pipe editor context into it.
      mux = {
        backend = "tmux",
        enabled = true,
        create = "split",
      },
    },
  },
  -- Sidekick is used purely as a context bridge: launch/navigate a coding CLI with tmux, and only send context from
  -- the editor.
  keys = {
    {
      "<leader>at",
      function() send({ msg = "{this}" }) end,
      mode = { "n", "x" },
      desc = "Send This / Selection",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt({
          cb = function(_, text)
            if text then send({ text = text }) end
          end,
        })
      end,
      mode = { "n", "x" },
      desc = "Select Prompt",
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
    require("which-key").add({ { "<leader>a", group = "AI" } })
  end,
}
