local M = {}

function M.setup(opts)
  require("batphone.options")
  require("batphone.autocmds")
  vim.cmd("colorscheme kanagawa")
end

return M
