vim.keymap.set("n", "<leader>fs", "<cmd>source %<CR>", { desc = "Source file", buffer = true })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Source line", buffer = true })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Source block", buffer = true })
