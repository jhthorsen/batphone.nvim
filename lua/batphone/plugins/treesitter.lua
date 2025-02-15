-- :checkhealth nvim-treesitter
-- :TSInstall c lua markdown markdown_inline query vim vimdoc
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = require("batphone.language_servers").tree_sitter_ensure_installed,
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
  },
}
