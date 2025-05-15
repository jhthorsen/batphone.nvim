local function on_attach(_, _)
  local mapkey = require("batphone.utils").mapkey
  local snacks = require("snacks")

  local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go({ severity = severity })
    end
  end

  require("batphone.utils").set_diagnostics({})
  snacks.toggle.diagnostics():map("<leader>ud")

  mapkey("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  mapkey("n", "<leader>dn", diagnostic_goto(true), { desc = "Next Diagnostic" })
  mapkey("n", "<leader>dp", diagnostic_goto(false), { desc = "Prev Diagnostic" })
  mapkey("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  mapkey("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  mapkey("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  mapkey("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
  mapkey("i", "<leader>cS", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
  mapkey("n", "<leader>cR", function() snacks.rename.rename_file() end, { desc = "Rename File" })
  mapkey("n", "<leader>cl", function() snacks.picker.lsp_config() end, { desc = "Lsp Info" })
  mapkey("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Displays information about the symbol under the cursor in a floating window"})
  mapkey("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  mapkey("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
  mapkey("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
  mapkey("n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true })
  mapkey("n", "gy", vim.lsp.buf.type_definition, { desc = "Jumps to the definition of the type of the symbol under the cursor"})
end

return {
  on_attach = on_attach,
}
