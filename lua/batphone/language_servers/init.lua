local function on_attach(_, bufnr)
  local mapkey = require('batphone.utils').mapkey
  mapkey("i", "<c-k>", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
  mapkey("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
  mapkey("n", "<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
  mapkey("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
  mapkey("n", "K", function() return vim.lsp.buf.hover() end, { desc = "Displays information about the symbol under the cursor in a floating window"})
  mapkey("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  mapkey("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
  mapkey("n", "gK", function() return vim.lsp.buf.signature_help() end, { desc = "Signature Help" })
  mapkey("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
  mapkey("n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true })
  mapkey("n", "gy", vim.lsp.buf.type_definition, { desc = "Jumps to the definition of the type of the symbol under the cursor"})
  mapkey({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  mapkey({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
end

local tree_sitter_ensure_installed = {
  "bash",
  "c",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "git_config",
  "gitignore",
  "go",
  "golang",
  "gomod",
  "gotmpl",
  "gpg",
  "help",
  "html",
  "htmldjango",
  "javascript",
  "jinja",
  "jinja_inline",
  "jq",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nginx",
  "perl",
  "pod",
  "python",
  "regex",
  "rust",
  "scss",
  "sql",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vue",
  "yaml",
  "zig",
}

local servers = {}

servers.ansiblels = {}
servers.bashls = {}
servers.biome = {}
servers.clangd = {}
servers.css_variables = {}
servers.cssls = {}
servers.cssmodules_ls = {}
servers.dockerls = {}
servers.emmet_language_server = {}
servers.eslint = {}
servers.gopls = {}
servers.html = {}
servers.htmx = {}
servers.jinja_lsp = {}
servers.jqls = {}
servers.jsonls = {}
servers.nginx_language_server = {}
servers.perlnavigator = {}
servers.pylyzer = {}
servers.remark_ls = {}
servers.rust_analyzer = {}
servers.spectral = {}
servers.sqlls = {}
servers.svelte = {}
servers.templ = {}
servers.ts_ls = {}
servers.yamlls = {}

servers.lua_ls = {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      codeLens = {
        enable = true,
      },
      completion = {
        callSnippet = "Replace",
      },
      doc = {
        privateName = { "^_" },
      },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        paramName = "Disable",
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
}

return {
  on_attach = on_attach,
  servers = servers,
  tree_sitter_ensure_installed = tree_sitter_ensure_installed,
}
