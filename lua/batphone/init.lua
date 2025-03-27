local M = {}

function M.setup(opts)
  vim.cmd("colorscheme kanagawa-wave")
  require("batphone.options")
  require("batphone.clipboard")
  require("batphone.autocmds")
  require("batphone.keymaps.automagic")
  require("batphone.keymaps.user")
end

return M
