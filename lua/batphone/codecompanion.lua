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
    extensions = { },
    strategies = {
      chat = {
        adapter = vim.env.CODECOMPANION_ADAPTER or "copilot",
        model = vim.env.CODECOMPANION_MODEL or "o4-mini",
        keymaps = {
          close = {
            modes = { n = "q", i = "<c-c>" },
          },
        },
      },
      inline = {
        adapter = vim.env.CODECOMPANION_ADAPTER or "copilot",
      },
    },
    display = {
      chat = {
        window = {
          layout = "float",
          height = 0.7,
          width = 0.6,
          row = 10000,
          col = 10000,
          opts = {
            number = false,
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
      continue_last_chat = true,
    },
  },
}

function M.lazy(mod)
  return function()
    if not M.loaded then
      require("plenary")
      require("copilot").setup(M.copilot)
      require("copilot.auth").signin()

      if pcall(require, "codecompanion._extensions.history") then
        M.codecompanion.extensions.history = M.codecompanion_history
      end

      require("codecompanion").setup(M.codecompanion)

      M.loaded = true
    end

    return require(mod)
  end
end

return M
