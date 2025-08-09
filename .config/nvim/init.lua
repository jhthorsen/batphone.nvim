vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
  { src = "https://github.com/rebelot/kanagawa.nvim", version = "master" },
})

-- Either load jhthorsen.nvim from github...
-- vim.pack.add({{ src = "https://github.com/jhthorsen/jhthorsen.nvim", version = "main" }})
--- ...or from $HOME/.local/share/nvim/site/pack/core/opt/jhthorsen.nvim
vim.cmd("packadd jhthorsen.nvim")

require("jhthorsen.options")
require("jhthorsen.clipboard")
require("jhthorsen.theme").kanagawa("kanagawa-wave")
require("jhthorsen.keys").setup()

require("jhthorsen.autocmd_buf_enter_goto_last_loc")
require("jhthorsen.autocmd_buf_write_pre_mkdir")
