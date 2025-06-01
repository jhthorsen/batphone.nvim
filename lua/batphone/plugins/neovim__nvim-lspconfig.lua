return {
  "neovim/nvim-lspconfig",
  version = "*",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    { "saghen/blink.cmp" },
    { "williamboman/mason-lspconfig.nvim" },
  },
}
