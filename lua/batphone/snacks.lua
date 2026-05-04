local default_layout = {
  preview = "main",
  layout = {
    box = "vertical",
    backdrop = false,
    col = -1,
    row = -1,
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
}

local dropdown_layout = {
  preview = false,
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
}

return {
  opts = {
    notifier = {
      level = vim.log.levels.DEBUG,
      sort = { "added" },
    },
    picker = {
      formatters = {
        file = {
          truncate = 90,
        },
      },
      layout = default_layout,
      sources = {
        autocmds = { layout = { preview = false } },
        buffers = { layout = { preview = false } },
        command_history = { layout = { preview = false } },
        lines = { layout = { preview = false } },
        registers = { layout = { preview = false } },
        search_history = { layout = { preview = false } },
        select = { layout = dropdown_layout },
        spelling = { layout = dropdown_layout },
      },
    },
    styles = {
      notification = {
        zindex = 90,
      },
      zen = {
        minimal = true,
        border = "hpad",
        height = 0.9,
        width = function()
          local cols = vim.o.columns
          return cols > (100 + 4) and 100 or cols - 4
        end,
        backdrop = {
          transparent = false,
        },
      },
    },
    terminal = {
      shell = { vim.env.SHELL, "--login" },
    },
    zen = {
      toggles = {
        diagnostics = false,
        dim = false,
        git_signs = false,
        inlay_hints = false,
        mini_diff_signs = false,
      },
      win = {
        wo = {
          number = false,
          signcolumn = "no",
          wrap = true,
        },
      },
      zoom = {
        win = {
          border = false,
          minimal = false,
          height = 0,
          width = 0,
          wo = {
            number = true,
            signcolumn = "yes",
            wrap = false,
          },
        },
      },
    },
  },
}
