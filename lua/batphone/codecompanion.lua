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
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_tools = true,
            show_server_tools_in_chat = true,
            add_mcp_prefix_to_tool_names = false,
            show_result_in_chat = true,
            format_tool = nil,
            make_vars = false,
            make_slash_commands = true,
          }
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
