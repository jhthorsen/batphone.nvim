local layout = {
  default = {
    preview = "main",
    layout = {
      box = "vertical",
      backdrop = false,
      col = -1,
      row = -2,
      width = function()
        if vim.o.columns < 90 then return 0.9
        else return 90 end
      end,
      height = 20,
      border = "rounded",
      title = " {title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "none" },
      { win = "list", border = "none" },
      { win = "preview", title = "{preview}" },
    },
  },
  dropdown = {
    preview = "none",
    layout = {
      box = "vertical",
      backdrop = false,
      relative = "cursor",
      col = 1,
      row = 1,
      width = 0.4,
      height = 7,
      border = "rounded",
      { win = "list", border = "none" },
    },
  },
  no_preview = {
    preview = false,
  },
}

return {
  "folke/snacks.nvim",
  version = "*",
  lazy = false,
  priority = 1000,
  keys = require("batphone.keymaps").snacks,
  opts = {
    picker = {
      prompt = " ",
      layout = layout.default,
      formatters = {
        file = {
          truncate = 90,
        },
      },
      sources = {
        autocmds = { layout = layout.no_preview },
        buffers = { layout = layout.no_preview },
        command_history = { layout = layout.no_preview },
        lines = { layout = layout.no_preview },
        notifications = { layout = layout.no_preview },
        search_history = { layout = layout.no_preview },
        spelling = { layout = layout.dropdown },
      },
    }, -- end picker
    styles = {
      zen = {
        height = 0.95,
        width = function()
          local cols = vim.o.columns
          if cols > 122 then return 120 end
          return cols - 6
        end,
        minimal = true,
        backdrop = {
          transparent = true,
          blend = 10,
        },
      },
    },
    terminal = {
      shell = { vim.env.NVIM_TERMINAL_SHELL or vim.env.SHELL or "bash" }
    },
    zen = {
      toggles = {
        diagnostics = false,
        dim = false,
        git_signs = false,
        inlay_hints = false,
        mini_diff_signs = false,
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    require("batphone.keymaps").keys_snacks()
  end,
}
