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

local lsp_servers = {}

lsp_servers.ansiblels = {}
lsp_servers.bashls = {}
lsp_servers.biome = {}
lsp_servers.clangd = {}
lsp_servers.css_variables = {}
lsp_servers.cssls = {}
lsp_servers.cssmodules_ls = {}
lsp_servers.dockerls = {}
lsp_servers.emmet_language_server = {}
lsp_servers.eslint = {}
lsp_servers.gopls = {}
lsp_servers.html = {}
lsp_servers.htmx = {}
lsp_servers.jinja_lsp = {}
lsp_servers.jqls = {}
lsp_servers.jsonls = {}
lsp_servers.nginx_language_server = {}
lsp_servers.perlnavigator = {}
lsp_servers.pylyzer = {}
lsp_servers.remark_ls = {}
lsp_servers.rust_analyzer = {}
lsp_servers.sqlls = {}
lsp_servers.svelte = {}
lsp_servers.templ = {}
lsp_servers.ts_ls = {}
lsp_servers.yamlls = {}

lsp_servers.lua_ls = {
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
  lsp_servers = lsp_servers,
  tree_sitter_ensure_installed = tree_sitter_ensure_installed,
}
