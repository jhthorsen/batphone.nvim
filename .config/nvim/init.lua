vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
  { src = "https://github.com/rebelot/kanagawa.nvim", version = "master" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/echasnovski/mini.nvim", version = "main" },
  { src = "https://github.com/jake-stewart/multicursor.nvim", version = "main" },
  { src = "https://github.com/folke/snacks.nvim", version = "main" },
  { src = "https://github.com/folke/which-key.nvim", version = "main" },
  { src = "https://github.com/mason-org/mason.nvim", version = "main" },
  { src = "https://github.com/zbirenbaum/copilot.lua", version = "master" },
  { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim", version = vim.version.range("4") },
  { src = "https://github.com/folke/lazydev.nvim", version = "main" },
  { src = "https://github.com/fang2hou/blink-copilot", version = "main" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("6") },
  { src = "https://github.com/stevearc/oil.nvim", version = vim.version.range("2") },
})

-- Either load batphone.nvim from github...
-- vim.pack.add({{ src = "https://github.com/jhthorsen/batphone.nvim", version = "v2.x.x" }})
--- ...or from $HOME/.local/share/nvim/site/pack/core/opt/batphone.nvim
vim.cmd("packadd batphone.nvim")

require("mini.align").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("nvim-treesitter").setup({})

require("batphone.options")
require("batphone.clipboard")
require("batphone.theme").kanagawa("kanagawa-wave")
require("batphone.statusline").setup()

require("batphone.autocmd_buf_enter_goto_last_loc")
require("batphone.autocmd_buf_write_pre_mkdir")
require("batphone.autocmd_lsp_attach_settings")

require("batphone.keys").auto()
require("batphone.keys").buffers()
require("batphone.keys").edit()
require("batphone.keys").editor()
require("batphone.keys").copilot()
require("batphone.keys").mason()
require("batphone.keys").oil()
require("batphone.keys").snacks()

require("batphone.multicursor").setup()
require("batphone.which_key").setup()

require("batphone.util").lsp_enable({
  "ansiblels",
  "bashls",
  "cssls",
  "cssmodules_ls",
  "denols",
  "dprint",
  "emmet_language_server",
  "gopls",
  "html",
  "htmx",
  "jinja_lsp",
  "jsonls",
  "lua_ls",
  "perlnavigator",
  "postgres_lsp",
  "prosemd_lsp",
  "pylsp",
  "quick_lint_js",
  "remark_ls",
  "sqlls",
  "svelte",
  "systemd_ls",
  "textlsp",
  "yamlls",
})

require("batphone.util").treesitter_install({
  "bash",
  "css",
  "gitcommit",
  "golang",
  "html",
  "javascript",
  "jinja",
  "markdown",
  "perl",
  "python",
  "rust",
  "sql",
  "svelte",
  "yaml",
})
