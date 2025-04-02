local lsp_keymaps = require("batphone.keymaps.lsp")
local plugins_keymaps = require("batphone.keymaps.plugins")
local language_servers = require("batphone.language_servers")

return {
  {
    "folke/lazydev.nvim",
    version = "*",
    ft = "lua",
    opts = {
      library = {
        "folke/snacks.nvim",
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = {
      servers = language_servers.lsp_servers,
      codelens = { enabled = false },
      inlay_hints = { enabled = true },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      diagnostics = {
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        signs = {
          text = {
            Error = " ",
            Hint  = " ",
            Info  = " ",
            Warn  = " ",
          },
        },
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local blink = require("blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend(
          "force",
          { capabilities = vim.deepcopy(capabilities), on_attach = lsp_keymaps.on_attach },
          opts.servers[server] or {}
        )

        if server_opts.enabled ~= false then
          require("lspconfig")[server].setup(server_opts)
        end
      end

      local mlsp = require("mason-lspconfig")
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      local ensure_installed = {}
      for server, server_opts in pairs(opts.servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            elseif ensure_installed[server] == nil then
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      mlsp.setup({
        automatic_installation = true,
        ensure_installed = ensure_installed,
        handlers = { setup },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = language_servers.tree_sitter_ensure_installed,
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    version = "*",
    lazy = true,
    dependencies = {
      "fang2hou/blink-copilot",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = plugins_keymaps.blink,
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
        default = {
          "lazydev",
          "lsp",
          "snippets",
          "copilot",
          "buffer",
          "path",
        },
        providers = {
          buffer = {
            opts = {
              get_bufnrs = function()
                return vim.tbl_filter(
                  function(bufnr) return vim.bo[bufnr].buftype == '' end,
                  vim.api.nvim_list_bufs()
                )
              end,
            },
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
  },
  {
    "williamboman/mason.nvim",
    version = "*",
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = plugins_keymaps.mason,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    version = "*",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "VeryLazy",
    keys = plugins_keymaps.copilot,
    config = function(_, opts)
      if vim.env.ENABLE_COPILOT == "force" or vim.env.ENABLE_COPILOT == "yes" then
        require("copilot").setup(opts)
      end
    end,
    opts = {
      server_opts_overrides = {},
      suggestion = { debounce = 350 },
      should_attach = function(_, bufname)
        local logger = require("copilot.logger")
        if not vim.bo.buflisted then
          logger.debug("not attaching, buffer is not 'buflisted'")
          return false
        end
        if vim.bo.buftype ~= "" then
          logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
          return false
        end
        if vim.env.ENABLE_COPILOT == "force" then
          return true
        end
        if string.match(bufname, "_alien") then
          logger.debug("not attaching, buffer is /_alien/")
          return false
        end
        if string.match(bufname, "env") then
          logger.debug("not attaching, buffer is /env/")
          return false
        end

        return true
      end
    },
  },
}
