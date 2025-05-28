local M = {}

function M.setup(opts)
  vim.cmd("colorscheme kanagawa-wave")
  require("batphone.options")
  require("batphone.options.lsp")
  require("batphone.clipboard")
  require("batphone.autocmds.buf")
  require("batphone.autocmds.lsp")
  require("batphone.keymaps.automagic")
  require("batphone.keymaps.user")
end

return M
