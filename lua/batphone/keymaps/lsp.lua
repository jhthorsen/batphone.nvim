local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return function()
  local mapkey = require("batphone.utils").mapkey
  local set_diagnostics = require("batphone.utils").set_diagnostics
  local picker = require("snacks.picker")
  local toggle = require("snacks.toggle")

  toggle.diagnostics():map("<leader>ud")
  toggle.inlay_hints():map("<leader>uh")
  toggle.new({
    id = "diagnostics_virtual_lines",
    name = "Diagnostics virtual lines",
    get = function()
      return set_diagnostics(nil).virtual_lines
    end,
    set = function(virtual_lines)
      set_diagnostics({virtual_lines = virtual_lines})
    end
  }):map("<leader>uv")

  mapkey("i", "<leader>cS", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  mapkey("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
  mapkey("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  mapkey("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
  mapkey("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
  mapkey("n", "<leader>cl", function() picker.lsp_config() end, { desc = "Lsp Info" })
  mapkey("n", "<leader>cR", function() require("snacks.rename").rename_file() end, { desc = "Rename File" })
  mapkey("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "<leader>da", function() picker.diagnostics() end, { desc = "Workspace Diagnostics" })
  mapkey("n", "<leader>db", function() picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
  mapkey("n", "<leader>de", function() picker.diagnostics({ serverity = "error" }) end, { desc = "Workspace Errors" })
  mapkey("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  mapkey("n", "<leader>dn", diagnostic_goto(true), { desc = "Next Diagnostic" })
  mapkey("n", "<leader>dp", diagnostic_goto(false), { desc = "Prev Diagnostic" })
  mapkey("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "<leader>ss", function() picker.lsp_symbols() end, { desc = "LSP Symbols" })
  mapkey("n", "<leader>sS", function() picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
  mapkey("n", "gD", function() picker.lsp_declarations() end, { desc = "Goto Declaration" })
  mapkey("n", "gd", function() picker.lsp_definitions() end, { desc = "Goto Definition" })
  mapkey("n", "gI", function() picker.lsp_implementations() end, { desc = "Goto Implementation" })
  mapkey("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "gr", function() picker.lsp_references() end, { desc = "References", nowait = true })
  mapkey("n", "gy", function() picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
  mapkey("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Displays information about the symbol under the cursor in a floating window"})
end
