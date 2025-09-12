local M = {}

function M.setup()
  local features = {}
  for _, feature in ipairs(vim.split(vim.env.RUST_FEATURES or "", ",")) do
    if feature ~= "" then table.insert(features, feature) end
  end

  local settings = {
    cargo = {
      allFeatures = false,
      loadOutDirsFromCheck = false,
      features = features,
    },
    check = {
      features = features,
    },
  }

  vim.g.rustaceanvim = {
    server = {
      default_settings = {
        ['rust-analyzer'] = settings
     },
    }
  }

  vim.lsp.config('rust_analyzer', {
    settings = {
      ['rust-analyzer'] = settings
    }
  })
end

return M
