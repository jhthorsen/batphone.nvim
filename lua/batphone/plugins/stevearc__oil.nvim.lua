return {
  "stevearc/oil.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    { "echasnovski/mini.icons" },
  },
  keys = require("batphone.keymaps").oil,
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    float = {
      border = "rounded",
      max_width = 80,
      max_height = 0.6,
    },
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
    },
    view_options = {
      show_hidden = true,
    },
  },
}
