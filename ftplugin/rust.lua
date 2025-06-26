local function rust_lsp(action)
  return function() vim.cmd.RustLsp(action) end
end

vim.keymap.set("n", "K", rust_lsp({"hover", "actions"}), { desc = "RustLsp hover actions", silent = true, buffer = true })
vim.keymap.set("n", "<a-j>", rust_lsp({"moveItem",  "down"}), { desc = "RustLsp moveItem down", silent = true, buffer = true })
vim.keymap.set("n", "<a-k>", rust_lsp({"moveItem",  "up"}), { desc = "RustLsp moveItem up", silent = true, buffer = true })
vim.keymap.set("n", "<leader>a", rust_lsp("codeAction"), { desc = "RustLsp codeAction", silent = true, buffer = true })
vim.keymap.set("n", "<leader>ce", rust_lsp("expandMacro"), { desc = "RustLsp expandMacro", silent = true, buffer = true })
vim.keymap.set("n", "<leader>ch", rust_lsp("explainError"), { desc = "RustLsp explainError", silent = true, buffer = true })
