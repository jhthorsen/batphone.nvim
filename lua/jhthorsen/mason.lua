local M = {
  opts = {},
}

function M.load()
  local mason = require("mason")
  mason.setup(M.opts)
  M.load = function() return mason end
  return mason
end

function M.setup()
  vim.keymap.set(
    "n", "<leader>nM",
    function() M.load(); require("mason.ui").open() end,
    { desc = "Open Mason Package Manager" }
  )
end

return M
