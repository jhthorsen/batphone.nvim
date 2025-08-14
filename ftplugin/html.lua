local toggle = require("batphone.toggle").toggle;

toggle({
  key = "<leader>ch",
  desc = { enabled = "Switch to html", disabled = "Switch to htmldjango" },
  current = function() return vim.bo.filetype == "htmldjango" end,
  set = function(enabled) vim.bo.filetype = enabled and "html" or "htmldjango" end,
})
