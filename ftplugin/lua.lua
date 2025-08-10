require("jhthorsen.util").lsp_enable("lua_ls")
require("jhthorsen.util").treesitter_install("lua")

vim.keymap.set("n", "<leader>nR", ":update<cr>:restart<cr>", { desc = "Restart neovim", buffer = true })
vim.keymap.set("n", "<leader>fs", ":update<cr>:source %<cr>", { desc = "Source file", buffer = true })
vim.keymap.set("n", "<leader>x", ":.lua<cr>", { desc = "Source line", buffer = true, silent = true })
vim.keymap.set("v", "<leader>x", ":lua<cr>", { desc = "Source block", buffer = true, silent = true })
