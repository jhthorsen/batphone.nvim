return {
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function(_, _)
      -- require("mini.basics").setup() -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-basics.md#features
      require("mini.comment").setup()
      require("mini.surround").setup()
    end,
  },
  {
    "folke/flash.nvim",
    version = "*",
    lazy = true,
    keys = require("batphone.keymaps.plugins").flash,
  },
  {
    "brenton-leighton/multiple-cursors.nvim",
    version = "*",
    lazy = true,
    opts = {
      pre_hook = function()
        require("cmp").setup({ enabled = false })
      end,
      post_hook = function()
        require("cmp").setup({ enabled = true })
      end,
    },
    keys = require("batphone.keymaps.plugins").multi,
  },
  {
    "stevearc/conform.nvim",
    version = "*",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = require("batphone.keymaps.plugins").conform,
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
  },
}
