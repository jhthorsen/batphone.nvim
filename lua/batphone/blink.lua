return {
  opts = function(override)
    return vim.tbl_deep_extend("force", {
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 750 },
        menu = {
          draw = {
            columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
            treesitter = { "lsp" }
          },
        },
      },
      keymap = {
        preset = "default",
        ["<cr>"] = {
          function(ctx)
            local item = ctx.get_selected_item() or {}
            if item.source_id == "copilot" then return ctx.select_and_accept() end
            if item.source_id == "snippets" then return ctx.select_and_accept() end

            local col = vim.api.nvim_win_get_cursor(0)[2]
            if col == 0 then return nil end

            local line = vim.api.nvim_get_current_line()
            local word_before = line:sub(col, col):match("[%w_.]")
            if word_before ~= nil then return ctx.select_and_accept() end
          end,
          "fallback",
        },
        ["<tab>"] = {
          function(ctx) return ctx.select_next() end,
          "fallback",
        },
        ["<s-tab>"] = {
          function(ctx) return ctx.select_prev() end,
          "fallback",
        }
      },
      signature = {
        enabled = true
      },
      sources = {
        default = {
          "buffer",
          "lsp",
          "snippets",
          "path",
          "copilot",
          "codecompanion",
        },
        providers = {
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            min_keyword_length = 2,
            async = true,
            score_offset = 50,
            opts = {
              debounce = 500,
              max_completions = 2,
              max_attempts = 2,
            },
          },
        },
      },
    }, override)
  end
}
