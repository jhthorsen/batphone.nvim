local M = {}

function M.setup()
  vim.g.rustaceanvim = function()
    local features = {}
    for _, feature in ipairs(vim.split(vim.env.RUST_FEATURES or "", ",")) do
      if feature ~= "" then table.insert(features, feature) end
    end

    local linkedProjects = {}
    if vim.env.RUST_LINKED_PROJECTS then
      for _, project in ipairs(vim.split(vim.env.RUST_LINKED_PROJECTS, ",")) do
        if project ~= "" then table.insert(linkedProjects, project) end
      end
    end

    return {
      server = {
        default_settings = {
          ['rust-analyzer'] = {
            linkedProjects = linkedProjects,
            cargo = {
              allFeatures = false,
              loadOutDirsFromCheck = false,
              features = features,
            },
            check = {
              features = features,
            },
            inlayHints = {
              enable = false,
            },
            procMacos = {
              enable = true,
            },
          },
        },
      },
    }
  end
end

return M
