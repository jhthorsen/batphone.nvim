-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local function setup(name, config)
  if vim.env.BATPHONE_NVIM_CHECK == "1" then
    local lsp_path = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "nvim-lspconfig", "lsp")
    local lsp_config = io.open(vim.fs.joinpath(lsp_path, name .. ".lua"), "r")
    if lsp_config then io.close(lsp_config)
    else vim.print("lsp-config does not exists for " .. name) end
  end

  if config then vim.lsp.config(name, config) end
  vim.lsp.config(name, { auto_install_packages = config and true or false })
  if config then vim.lsp.enable(name) end
end

setup("ansiblels", {})
setup("bashls", {})
setup("biome", {})
setup("clangd", {})
setup("css_variables", {})
setup("cssls", {})
setup("cssmodules_ls", {})
setup("denols", {})
setup("dockerls", {})
setup("dprint", {})
setup("emmet_language_server", {})
setup("eslint", {})
setup("gopls", {})
setup("harper_ls", {})
setup("html", {})
setup("htmx", {})
setup("jqls", {})
setup("jsonls", {})
setup("markdown_oxide", {})
setup("marksman", {})
setup("nginx_language_server", {})
setup("oxlint", {})
setup("postgres_lsp", {})
setup("prosemd_lsp", {})
setup("pylyzer", {})
setup("quick_lint_js", {})
setup("rust_analyzer", {})
setup("spectral", {})
setup("svelte", {})
setup("systemd_ls", {})
setup("templ", {})
setup("textlsp", {})
setup("ts_ls", {})
setup("yamlls", {})
setup("zk", {})

setup("jinja_lsp", {
  settings = {
    ["jinja-lsp.hide_undefined"] = true,
  },
})

setup("lua_ls", {
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
})

setup("perlnavigator", {
  settings = {
    perlnavigator = {
      enableWarnings = true,
      perlcriticEnabled = false,
    },
  },
})

setup("sqlls", {
  settings = {
    sqlLanguageServer = {
      lint = {
        rules = {
          ["reserved-word-case"] = {},
        },
      },
    },
  },
})
