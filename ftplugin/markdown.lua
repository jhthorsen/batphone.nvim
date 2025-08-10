require("jhthorsen.util").lsp_enable("prosemd_lsp")
require("jhthorsen.util").lsp_enable("remark_ls")
require("jhthorsen.util").lsp_enable("textlsp")
require("jhthorsen.util").treesitter_install("markdown")

vim.opt_local.spell = true
vim.opt_local.wrap = true
