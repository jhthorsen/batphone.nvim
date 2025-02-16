local mapkey = require('batphone.utils').mapkey

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

mapkey("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
mapkey("n", "cn", diagnostic_goto(true), { desc = "Next Diagnostic" })
mapkey("n", "cp", diagnostic_goto(false), { desc = "Prev Diagnostic" })
mapkey("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
mapkey("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
mapkey("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
mapkey("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

Snacks.toggle.diagnostics():map("<leader>ud")

if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>uh")
end

-- Native snippets. Only needed on < 0.11, as 0.11 creates these by default
if vim.fn.has("nvim-0.11") == 0 then
  mapkey("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
  end, { expr = true, desc = "Jump Next" })
  mapkey({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
  end, { expr = true, desc = "Jump Previous" })
end
