return {
  "folke/which-key.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    expand = 2,
    plugins = {
      marks = true,
      registers = false,
      spelling = { enabled = false },
      presets = {
        g = true,
        motions = true,
        nav = true,
        operators = true,
        text_objects = true,
        windows = true,
        z = true,
      },
    },
  },
  keys = require("batphone.keymaps").which_key,
  config = function(_, opts)
    require("which-key.plugins.presets").operators["v"] = nil

    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<space>b", group = "Buffers...", },
      { "<space>c", group = "Code..." },
      { "<space>d", group = "Diagnostics..." },
      { "<space>f", group = "Files..." },
      { "<space>g", group = "Git..." },
      { "<space>m", group = "Multicursors...", icon = "󰎂" },
      { "<space>n", group = "Neovim...", icon = "" },
      { "<space>s", group = "Search..." },
      { "<space>u", group = "User Interface...", icon = "󰂮" },
    })
  end,
}
