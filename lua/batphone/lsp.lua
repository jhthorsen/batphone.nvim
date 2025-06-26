for _, name in ipairs(vim.split(vim.env.BATPHONE_LSP_ENABLE or "", ",")) do
  if name ~= "" then
    vim.lsp.config(name, { batphone_auto_install = true })
  end
end

for _, name in ipairs(vim.split(vim.env.BATPHONE_LSP_DISABLE or "", ",")) do
  if name ~= "" then
    vim.lsp.config(name, { batphone_auto_install = nil })
  end
end
