return {
  "rebelot/kanagawa.nvim",
  version = "*",
  priority = 1000,
  lazy = false,
  opts = {
    compile = false,
    dimInactive = false,
    commentStyle = { bold = false, italic = true },
    functionStyle = { bold = true, italic = false },
    keywordStyle = { bold = false, italic = false },
    statementStyle = { bold = false, italic = false },
    transparent = false,
    overrides = function(colors)
      local theme = colors.theme
      return {
        CursorLine = { bg = theme.ui.bg_p1 },
        CursorLineNr = { bg = theme.ui.bg_gutter, fg = theme.diag.warning, bold = false },
        LineNr = { bg = theme.ui.bg_gutter, fg = theme.ui.special, bold = false },
        Float = { bg = "none" },
      }
    end,
  },
}
