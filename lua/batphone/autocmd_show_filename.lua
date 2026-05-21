vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("batphone__autocmd_show_filename", { clear = true }),
  callback = function()
    local filename = vim.fn.expand("%:p")
    if filename ~= "" and vim.loop.fs_stat(filename) then
      vim.print(vim.fn.expand("%"))
    end
  end,
})
