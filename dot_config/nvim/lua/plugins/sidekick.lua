-- sidekick.nvim: run Claude Code in a split inside Neovim.
-- Deliberately NOT using LazyVim's `ai.sidekick` extra: that extra also enables the
-- Copilot language server for "next edit suggestions", and Copilot is removed.
return {
  {
    "folke/sidekick.nvim",
    opts = {
      nes = { enabled = false }, -- next edit suggestions need Copilot
    },
    -- stylua: ignore
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>aa", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Claude Code (toggle)" },
      { "<leader>at", function() require("sidekick.cli").send({ name = "claude", msg = "{this}" }) end, mode = { "x", "n" }, desc = "Send this to Claude" },
      { "<leader>af", function() require("sidekick.cli").send({ name = "claude", msg = "{file}" }) end, desc = "Send file to Claude" },
      { "<leader>av", function() require("sidekick.cli").send({ name = "claude", msg = "{selection}" }) end, mode = { "x" }, desc = "Send selection to Claude" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Pick a prompt" },
      { "<c-.>", function() require("sidekick.cli").focus() end, mode = { "n", "x", "i", "t" }, desc = "Switch focus to/from Claude" },
    },
  },
}
