return {
  "williamboman/mason.nvim",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  build = ":MasonUpdate",
  dependencies = {
    { "williamboman/mason-lspconfig.nvim" },
  },
  keys = require("batphone.keymaps").mason,
  config = function(_, opts)
    require("mason").setup(opts)
  end
}
