return {
  opts = function(override)
    local opts = {
      extensions = {
        history = {
          enabled = true,
          opts = {
            picker = "snacks",
          },
        },
      },
      interactions = {
        chat = {
          adapter = {
            name = vim.env.CODECOMPANION_ADAPTER or "copilot",
            model = vim.env.CODECOMPANION_MODEL or "claude-sonnet-4.5",
          },
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
          adapter = {
            name = vim.env.CODECOMPANION_ADAPTER or "copilot",
            model = vim.env.CODECOMPANION_MODEL or "claude-sonnet-4.5",
          },
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
    }

    local history_ok = pcall(require, "codecompanion._extensions.history")
    if not history_ok then
      opts.extensions.history = nil
    end

    local filename = vim.api.nvim_buf_get_name(0)
    local adapter = string.match(filename or "", "([^/]+)%.ai$")
    if adapter then
      opts.interactions.chat.adapter.name = adapter
      require("batphone.util").once("CodeCompanionLoaded", function()
        vim.cmd("CodeCompanionChat")
      end)
    end

    return vim.tbl_deep_extend("force", opts, override)
  end
}
