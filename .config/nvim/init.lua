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
  { src = "https://github.com/rafamadriz/friendly-snippets", version = "main" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
  { src = "https://github.com/fang2hou/blink-copilot", version = "main" },
  { src = "https://github.com/ravitemer/codecompanion-history.nvim", version = "main" },
  { src = "https://github.com/olimorris/codecompanion.nvim", version = vim.version.range("17") },
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("6") },
  { src = "https://github.com/stevearc/quicker.nvim", version = "master" },
  { src = "https://github.com/uga-rosa/ccc.nvim", version = "main" },
})

-- Either load batphone.nvim from github...
-- vim.pack.add({{ src = "https://github.com/jhthorsen/batphone.nvim", version = "v2.x.x" }})
--- ...or from $HOME/.local/share/nvim/site/pack/core/opt/batphone.nvim
vim.cmd("packadd batphone.nvim")

require("vim._extui").enable({})
require("snacks").setup(require("batphone.snacks").opts)
require("quicker").setup(require("batphone.quicker").opts)
require("mini.align").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("nvim-treesitter").setup({})

require("batphone.options")
require("batphone.clipboard")
require("batphone.theme").kanagawa("kanagawa-wave")
require("batphone.statusline").setup()

require("batphone.lsp_progress")
require("batphone.autocmd_buf_enter_goto_last_loc")
require("batphone.autocmd_buf_read_post_activate_ccc")
require("batphone.autocmd_buf_write_pre_mkdir")
require("batphone.autocmd_lsp_attach_settings")

require("batphone.keys").auto()
require("batphone.keys").buffers()
require("batphone.keys").edit()
require("batphone.keys").editor()
require("batphone.keys").codecompanion()
require("batphone.keys").mason()
require("batphone.keys").quicker()
require("batphone.keys").snacks()

require("batphone.multicursor").setup()
require("batphone.rust").setup()
require("batphone.which_key").setup()

require("batphone.util").lsp_enable({
  -- "ansiblels",
  "bashls",
  "css_variables",
  "cssls",
  "cssmodules_ls",
  "denols",
  -- "docker_language_server", -- Golang based
  -- "dockerls", -- Node based
  "dprint", -- Code formatter
  "emmet_language_server",
  -- "emmet_ls", -- Deprecated?
  "gh_actions_ls",
  -- "gitlab_ci_ls",
  "gopls",
  "harper_ls",
  "html",
  "htmx",
  "jinja_lsp",
  "jsonls",
  "lua_ls",
  "marksman", -- Markdown LSP server
  -- "nginx_language_server",
  "perlnavigator",
  -- "postgres_lsp",
  -- "pylsp", -- Python 3.6+
  "quick_lint_js",
  -- "remark_ls", -- Ecosystem of plugins that work with markdown as structured data
  -- "rpmspec", -- pip install rpm-spec-language-server
  "sqlls",
  "svelte",
  "systemd_ls",
  -- "templ",
  -- "textlsp", -- Text spell and grammar checking with various AI tools.
  "yamlls",
})

require("batphone.util").treesitter_install({
  "bash",
  "css",
  "gitcommit",
  "golang",
  "html",
  "htmldjango",
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
