local M = {
  opts = {
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    float = {
      border = "rounded",
      max_width = 80,
      max_height = 0.6,
    },
    keymaps = {
      ["q"] = { "actions.close", mode = "n" },
    },
    view_options = {
      show_hidden = true,
    },
  },
}

function M.lazy(mod)
  return function()
    if not M.loaded then
      require("oil").setup(M.opts)
      M.loaded = true
    end

    return require(mod or "oil")
  end
end

return M
