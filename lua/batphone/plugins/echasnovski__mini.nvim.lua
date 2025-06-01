return {
  "echasnovski/mini.nvim",
  version = "*",
  event = "VeryLazy",
  keys = require("batphone.keymaps").mini,
  config = function(_, _)
    require("mini.ai").setup()
    require("mini.align").setup()
    require("mini.comment").setup()
    require("mini.move").setup()
    require("mini.surround").setup()
  end,
}
