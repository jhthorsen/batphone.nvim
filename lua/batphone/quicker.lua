local M = {
  opts = {
    keys = {
      { ">",
        function() require("quicker").expand({ before = 1, after = 1, add_to_existing = true }) end,
        desc = "Expand quickfix context",
      },
      { "<",
        function() require("quicker").collapse() end,
        desc = "Collapse quickfix context",
      },
    },
  },
}

function M.lazy(mod)
  return function()
    if not M.loaded then
      require("quicker").setup(M.opts)
      M.loaded = true
    end

    return require(mod or "quicker")
  end
end

return M
