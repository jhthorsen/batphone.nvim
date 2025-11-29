local M = {
  opts = {
    preset = "helix",
    expand = function(node)
      local children = node:count()
      return node:can_expand() == false and children > 0 and children <= 2
    end,
    sort = { "group", "alphanum" },
    plugins = {
      marks = true,
      registers = false,
      spelling = { enabled = false },
      presets = {
        g = true,
        motions = true,
        nav = true,
        operators = true,
        text_objects = true,
        windows = true,
        z = true,
      },
    },
  },
}

function M.setup()
  local wk = require("which-key")
  wk.setup(M.opts)

  require("which-key.plugins.presets").operators["v"] = nil
  require("batphone.keys").which_key(wk)

  wk.add({
    { "<space>c", group = "Code..." },
    { "<space>d", group = "Diagnostics..." },
    { "<space>f", group = "Files..." },
    { "<space>g", group = "Git..." },
    { "<space>m", group = "Multicursors...", icon = "󰎂" },
    { "<space>n", group = "Neovim...", icon = "" },
    { "<space>r", group = "Rust...", icon = "" },
    { "<space>s", group = "Search..." },
    { "<space>u", group = "User Interface...", icon = "󰂮" },
    { "<space>q", group = "Quit..." },
  })
end

return M
