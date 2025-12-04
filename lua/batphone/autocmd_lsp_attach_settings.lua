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
      },
    },
  },
  codecompanion = {
    extensions = {},
    strategies = {
      chat = {
        adapter = vim.env.CODECOMPANION_ADAPTER or "copilot",
        model = vim.env.CODECOMPANION_MODEL or "o4-mini",
        keymaps = {
          close = {
            modes = { n = "q" },
          },
          stop = {
            modes = { n = "<c-c>", i = "<c-c>" },
          },
        },
      },
      inline = {
        adapter = vim.env.CODECOMPANION_ADAPTER or "copilot",
      },
    },
    display = {
      action_palette = {
        provider = "snacks",
      },
      chat = {
        window = {
          layout = "horizontal",
          position = "bottom",
          height = 0.7,
          width = 0.45,
          opts = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
          },
        },
      },
    },
  },
  codecompanion_history = {
    enabled = true,
    opts = {
      picker = "snacks",
    },
  },
  copilot = {
    auto_trigger = false,
    suggestion = { debounce = 350 },
    should_attach = function(_, bufname)
      if not vim.bo.buflisted then return false end
      if vim.bo.buftype ~= "" then return false end
      if vim.env.ATTACH_COPILOT == "yes" then return true end
      if string.match(bufname, ".env") then return false end
      if string.match(bufname, "_alien") then return false end
      return true
    end
  },
  diagnostic = {
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
  },
}

function M.blink_sources()
  local default = {}

  table.insert(default, "buffer")
  table.insert(default, "lsp")
  table.insert(default, "snippets")
  table.insert(default, "path")

  if pcall(require, "blink-copilot") then
    table.insert(default, "copilot")
  end
  if pcall(require, "codecompanion") then
    table.insert(default, "codecompanion")
  end

  return default
end

vim.api.nvim_create_autocmd("LspAttach", {
  once = true,
  callback = function(ev)
    vim.diagnostic.config(M.diagnostic)
    vim.lsp.inlay_hint.enable(false)

    pcall(function()
      require("copilot").setup(M.copilot)
      require("copilot.auth").signin()
      vim.cmd("doautocmd User CopilotLoaded")
    end)

    if pcall(require, "codecompanion._extensions.history") then
      M.codecompanion.extensions.history = M.codecompanion_history
    end

    pcall(function()
      require("plenary") -- required by codecompanion
      require("codecompanion").setup(M.codecompanion)
      vim.cmd("doautocmd User CodeCompanionLoaded")
    end)

    require("blink.cmp").setup(vim.tbl_deep_extend("force", {
      keymap = require("batphone.keys").blink(),
      sources = { default = M.blink_sources() },
    }, M.blink))

    require("batphone.keys").lsp()
  end,
})
