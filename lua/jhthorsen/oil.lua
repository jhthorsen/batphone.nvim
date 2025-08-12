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

function M.setup()
  local oil = require("oil")
  oil.setup(M.opts)
  require("jhthorsen.keys").oil(oil)
end

return M
