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
    "jake-stewart/multicursor.nvim",
    version = "*",
    event = "VeryLazy",
    keys = require("batphone.keymaps.plugins").multicursor,
    opts = {},
  },
}
