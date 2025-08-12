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
  { src = "https://github.com/copilotc-nvim/copilotchat.nvim", version = "main" },
  { src = "https://github.com/folke/lazydev.nvim", version = "main" },
  { src = "https://github.com/fang2hou/blink-copilot", version = "main" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.6") },
  { src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("6.7") },
  { src = "https://github.com/stevearc/oil.nvim", version = "main" },
})

-- Either load jhthorsen.nvim from github...
-- vim.pack.add({{ src = "https://github.com/jhthorsen/jhthorsen.nvim", version = "main" }})
--- ...or from $HOME/.local/share/nvim/site/pack/core/opt/jhthorsen.nvim
vim.cmd("packadd jhthorsen.nvim")

require("mini.align").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("nvim-treesitter").setup({})

require("jhthorsen.options")
require("jhthorsen.clipboard")
require("jhthorsen.theme").kanagawa("kanagawa-wave")
require("jhthorsen.statusline").setup()

require("jhthorsen.autocmd_buf_enter_goto_last_loc")
require("jhthorsen.autocmd_buf_write_pre_mkdir")
require("jhthorsen.autocmd_lsp_attach_settings")

require("jhthorsen.keys").auto()
require("jhthorsen.keys").buffers()
require("jhthorsen.keys").edit()
require("jhthorsen.keys").editor()
require("jhthorsen.keys").copilot()
require("jhthorsen.keys").mason()
require("jhthorsen.keys").oil()
require("jhthorsen.keys").snacks()

require("jhthorsen.multicursor").setup()
require("jhthorsen.which_key").setup()
