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
  if M.loaded then return end

  local wk = require("which-key")
  wk.setup(M.opts)
  require("which-key.plugins.presets").operators["v"] = nil

  wk.add({
    { "<leader>h", function() wk.show() end, icon = "🎹", desc = "Show All Keys" },
    { "<leader>c", group = "Code..." },
    { "<leader>d", group = "Diagnostics..." },
    { "<leader>f", group = "Files..." },
    { "<leader>g", group = "Git..." },
    { "<leader>m", group = "Multicursors...", icon = "󰎂" },
    { "<leader>n", group = "Neovim...", icon = "" },
    { "<leader>r", group = "Rust...", icon = "" },
    { "<leader>s", group = "Search..." },
    { "<leader>u", group = "User Interface...", icon = "󰂮" },
    { "<leader>q", group = "Quit..." },
  })
end

return M
