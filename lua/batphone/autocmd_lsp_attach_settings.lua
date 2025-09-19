local M = {
  blink = {
    appearance = {
      use_nvim_cmp_as_default = false,
    },
    cmdline = {
      enabled = false,
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 750,
      },
      ghost_text = {
        enabled = true,
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        }
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
    },
    sources = {
      -- default = sources,
      providers = {
        buffer = {
          opts = {
            get_bufnrs = function()
              return vim.tbl_filter(
                function(bufnr) return vim.bo[bufnr].buftype == "" end,
                vim.api.nvim_list_bufs()
              )
            end,
          },
        },
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
          score_offset = 1,
          enabled = true,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          async = true,
          score_offset = 100,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- make lazydev completions top priority (see `:h blink.cmp`)
        },
      },
    },
  },
}

function M.blink_sources()
  local default = {}
  if pcall(require, "lazydev") then
    table.insert(default, "lazydev")
  end

  table.insert(default, "buffer")
  table.insert(default, "lsp")
  table.insert(default, "snippets")
  table.insert(default, "path")

  local blink_copilot = require("batphone.codecompanion").lazy("blink-copilot")
  if pcall(blink_copilot) then
    table.insert(default, "copilot")
  end

  if pcall(require, "codecompanion") then
    table.insert(default, "codecompanion")
  end

  return { default = default }
end

function M.server_capabilities(capabilities)
  capabilities.textDocument = vim.tbl_deep_extend("force",
    capabilities.textDocument or {},
    {
      completion = {
       completionItem = {
         snippetSupport = true,
         preselectSupport = true,
         labelDetailsSupport = true,
         commitCharactersSupport = true,
         documentationFormat = { "markdown", "plaintext" },
       },
      },
      hover = {
        contentFormat = { "markdown", "plaintext" },
      },
      signatureHelp = {
        signatureInformation = {
          documentationFormat = { "markdown", "plaintext" },
        },
      },
    }
  )

  capabilities.workspace = vim.tbl_deep_extend("force",
    capabilities.workspace or {},
    {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    }
  )

  return capabilities
end

function M.config_diagnostics()
  local signs = {
    Hint = ">",
    Info = " ",
    Warn = "⚠️",
    Error = "‼️",
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  vim.diagnostic.config({
    severity_sort = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
    virtual_lines = false,
    signs = {
      text = {
        [vim.diagnostic.severity.HINT] = signs.Hint,
        [vim.diagnostic.severity.INFO] = signs.Info,
        [vim.diagnostic.severity.WARN] = signs.Warn,
        [vim.diagnostic.severity.ERROR] = signs.Error,
      },
    },
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("batphone__lsp_attach_settings", { clear = true }),
  callback = function(ev)
    vim.api.nvim_del_augroup_by_name("batphone__lsp_attach_settings") -- Only need to run this once
    local ok, blink, lazydev

    vim.lsp.inlay_hint.enable(false)
    M.config_diagnostics()

    ok, lazydev = pcall(require, "lazydev")
    if ok then
      lazydev.setup({
        library = {
          "folke/snacks.nvim",
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      })
    end

    ok, blink = pcall(require, "blink.cmp")
    if ok then
      blink.setup(vim.tbl_deep_extend("force",
        {
          keymap = require("batphone.keys").blink(),
          sources = M.blink_sources({ lazydev = lazydev }),
        },
        M.blink
      ))
    end

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client ~= nil and client.server_capabilities ~= nil then
      client.server_capabilities = M.server_capabilities(client.server_capabilities)
    end

    require("batphone.keys").lsp()
  end,
})
