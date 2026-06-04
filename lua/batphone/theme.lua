local M = {}

function M.kanagawa(scheme_name)
  require("kanagawa").setup({
    dimInactive = false,
    commentStyle = { bold = false, italic = true },
    functionStyle = { bold = true, italic = false },
    keywordStyle = { bold = false, italic = false },
    statementStyle = { bold = false, italic = false },
    transparent = false,
    overrides = function(colors)
      local c = colors.theme
      return {
        CursorLine = { bg = c.ui.bg_p1 },
        CursorLineNr = { bg = c.ui.bg_gutter, fg = c.diag.warning, bold = false },
        Float = { bg = "none" },
        FloatBorder = { bg = c.ui.float.bg, fg = c.ui.float.fg },
        InactiveWindow = { bg = c.ui.bg_m2, fg = c.ui.fg_dim },
        LineNr = { bg = c.ui.bg_gutter, fg = c.ui.special, bold = false },
        NormalFloat = { bg = c.ui.bg_m2 },
      }
    end,
  })

  vim.cmd("colorscheme " .. (scheme_name or "kanagawa-wave"))
  vim.cmd(":hi statusline guibg=NONE")

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesWindowUpdate",
    callback = function(args)
      local win_id = args.data.win_id
      vim.wo[win_id].winblend = 1
      local config = vim.api.nvim_win_get_config(win_id)
      config.relative = "laststatus"
      config.height = 16
      vim.api.nvim_win_set_config(win_id, config)
    end,
  })
end

return M
