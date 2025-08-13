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
        LineNr = { bg = c.ui.bg_gutter, fg = c.ui.special, bold = false },
        Float = { bg = "none" },
      }
    end,
  })

  vim.cmd("colorscheme " .. (scheme_name or "kanagawa-wave"))
  vim.cmd(":hi statusline guibg=NONE")
end

return M
