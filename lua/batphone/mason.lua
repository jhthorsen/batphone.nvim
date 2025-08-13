local M = {
  opts = {},
}

function M.lazy(mod)
  return function()
    if not M.loaded then
      require("mason").setup(M.opts)
      M.loaded = true
    end

    return require(mod or "mason")
  end
end

return M
