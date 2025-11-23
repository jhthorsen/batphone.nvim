local M = {
  blink = {
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 750 },
      menu = {
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
          treesitter = { "lsp" }
        },
      },
    },
    signature = { enabled = true },
    sources = {
      providers = {
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          min_keyword_length = 3,
          async = true,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
        },
      },
    },
  },
}

function M.blink_sources()
  local default = {}

  require("lazydev").setup({
    library = {
      "folke/snacks.nvim",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })

  table.insert(default, "lazydev")
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

  return default
end

function M.config_diagnostics()
  vim.diagnostic.config({
    severity_sort = true,
    underline = false,
    update_in_insert = false,
    virtual_text = false,
    virtual_lines = false,
    signs = {
      text = {
        [vim.diagnostic.severity.HINT] = ">",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.WARN] = "⚠️",
        [vim.diagnostic.severity.ERROR] = "‼️",
      },
    },
  })
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("batphone__lsp_attach_settings", { clear = true }),
  callback = function(ev)
    vim.api.nvim_del_augroup_by_name("batphone__lsp_attach_settings") -- Only need to run this once
    vim.lsp.inlay_hint.enable(false)
    M.config_diagnostics()

    require("blink.cmp").setup(vim.tbl_deep_extend("force", {
      keymap = require("batphone.keys").blink(),
      sources = { default = M.blink_sources() },
    }, M.blink))

    require("batphone.keys").lsp()
  end,
})
