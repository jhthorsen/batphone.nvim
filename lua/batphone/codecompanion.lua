local M = {
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
}

function M.cmd(command)
  local config = M.lazy("codecompanion.config")
  return function()
    config().config.display.chat.window.layout = vim.o.columns > 200 and "vertical" or "horizontal"
    vim.cmd(command)
  end
end

function M.copilot_enable(enable)
  M.lazy()()
  vim.cmd(enable and "Copilot enable" or "Copilot disable")
end

function M.copilot_is_enabled()
  return M.loaded and M.lazy("copilot.client")().buf_is_attached(0)
end

function M.lazy(mod)
  return function()
    if not M.loaded then
      require("plenary")

      if pcall(require, "copilot") then
        require("copilot").setup(M.copilot)
        require("copilot.auth").signin()
      end

      if pcall(require, "codecompanion._extensions.history") then
        M.codecompanion.extensions.history = M.codecompanion_history
      end

      require("codecompanion").setup(M.codecompanion)

      M.loaded = true
    end

    return mod and require(mod)
  end
end

return M
