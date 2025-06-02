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
    require("which-key").setup(opts)
  end,
}
