local features = {}
for _, feature in ipairs(vim.split(vim.env.CARGO_FEATURES or "", ",")) do
  if feature ~= "" then table.insert(features, feature) end
end

return {
  batphone_auto_install = true,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = false,
        features = features,
        loadOutDirsFromCheck = false,
      },
      check = {
        features = features,
      },
    }
  }
}
