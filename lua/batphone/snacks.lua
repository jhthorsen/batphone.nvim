local default_layout = {
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

local no_preview_layout = {
  preview = false,
}

local sidebar_layout = {
  preview = "main",
  layout = {
    width = 40,
    min_width = 30,
    height = 0,
    position = "right",
    border = "none",
    box = "vertical",
    { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
    { win = "list", border = "none" },
    { win = "preview", title = "{preview}", height = 0.4, border = "top" },
  },
}

return {
  opts = {
    explorer = {
      replace_netrw = true,
    },
    picker = {
      formatters = {
        file = {
          truncate = 90,
        },
      },
      layout = default_layout,
      sources = {
        autocmds = { layout = no_preview_layout },
        explorer = { layout = sidebar_layout },
        buffers = { layout = no_preview_layout },
        command_history = { layout = no_preview_layout },
        lines = { layout = no_preview_layout },
        notifications = { layout = no_preview_layout },
        registers = { layout = no_preview_layout },
        search_history = { layout = no_preview_layout },
        select = { layout = dropdown_layout },
        spelling = { layout = dropdown_layout },
      },
    },
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
}
