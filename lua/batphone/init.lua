local M = {}

function M.setup(opts)
  vim.cmd("colorscheme kanagawa")
  require("batphone.options")
  require("batphone.autocmds")
  require("batphone.keymaps.automagic")
  require("batphone.keymaps.user")
end

return M
