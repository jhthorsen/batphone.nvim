local M = {}

function M.setup(_opts)
  local colorscheme = vim.env.NVIM_COLORSCHEME or "kanagawa-wave"
  vim.cmd("colorscheme " .. colorscheme)
  require("batphone.options")
  require("batphone.lsp")

  local keymaps = require("batphone.keymaps")
  keymaps.keys_automagic()
  keymaps.keys_additional()

  require("batphone.clipboard")
  require("batphone.autocmds")
end

return M
