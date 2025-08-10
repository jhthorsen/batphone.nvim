vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
  { src = "https://github.com/rebelot/kanagawa.nvim", version = "master" },
  { src = "https://github.com/echasnovski/mini.nvim", version = "main" },
  { src = "https://github.com/jake-stewart/multicursor.nvim", version = "main" },
  { src = "https://github.com/folke/snacks.nvim", version = "main" },
})

-- Either load jhthorsen.nvim from github...
-- vim.pack.add({{ src = "https://github.com/jhthorsen/jhthorsen.nvim", version = "main" }})
--- ...or from $HOME/.local/share/nvim/site/pack/core/opt/jhthorsen.nvim
vim.cmd("packadd jhthorsen.nvim")

require("mini.align").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})

require("jhthorsen.options")
require("jhthorsen.clipboard")
require("jhthorsen.theme").kanagawa("kanagawa-wave")
require("jhthorsen.keys").setup()
require("jhthorsen.statusline").setup()

require("jhthorsen.autocmd_buf_enter_goto_last_loc")
require("jhthorsen.autocmd_buf_write_pre_mkdir")

require("jhthorsen.multicursor").setup()
require("jhthorsen.snacks").setup()
