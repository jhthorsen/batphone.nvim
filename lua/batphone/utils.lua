local M = {}

function M.mapkey(mode, key, action, opts)
  local defaults = { silent = true }
  vim.keymap.set(mode, key, action, vim.tbl_extend("force", defaults, opts))
end

return M
