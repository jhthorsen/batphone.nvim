local M = {}

function M.setup(opts)
  vim.cmd("colorscheme kanagawa")
  require("batphone.options")
  require("batphone.autocmds")
  require("batphone.keymaps.automagic")
  require("batphone.keymaps.user")
  require("batphone.keymaps.lsp")
  require("batphone.keymaps.ui")
end

return M
