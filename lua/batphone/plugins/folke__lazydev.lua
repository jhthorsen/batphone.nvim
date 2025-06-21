return {
  "folke/lazydev.nvim",
  version = "*",
  ft = "lua",
  opts = {
    library = {
      "folke/snacks.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
  config = function(_, opts)
    require("lazydev").setup(opts)
    require("batphone.keymaps").keys_filetype_lua()
  end,
}
