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
}
