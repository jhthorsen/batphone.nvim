return {
  "stevearc/conform.nvim",
  version = "*",
  lazy = true,
  cmd = "ConformInfo",
  keys = require("batphone.keymaps").conform,
  opts = {
    default_format_opts = {
      async = false,
      lsp_format = "fallback",
      quiet = false,
      timeout_ms = 3000,
    },
    formatters_by_ft = {
      fish = { "fish_indent" },
      lua = { "stylua" },
      sh = { "shfmt" },
    },
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
  },
}
