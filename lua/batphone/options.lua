vim.g.mapleader = " "

vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.linebreak = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.mouse = ""
vim.opt.background = "dark"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.numberwidth = 4
vim.opt.scrolloff = 8
vim.opt.showtabline = 0

vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.ignorecase = false
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = false

vim.opt.timeoutlen = 250
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
vim.opt.undofile = true

vim.opt.signcolumn = "yes"
vim.opt.virtualedit = "block"
vim.opt.isfname:append("@-@")
vim.opt.errorbells = false
vim.opt.foldenable = false
vim.opt.lazyredraw = true
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest:list", "full" }
vim.opt.winborder = "rounded"

vim.diagnostic.config({
  severity_sort = false,
  signs = true,
  underline = false,
  update_in_insert = true,
  virtual_text = false,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LspAttached",
  callback = function(args)
    local ft = vim.opt_local.filetype:get()

    -- Avoid indenting attributes in html files
    -- It did not work adding this to ftplugin/. nor after/ftplugin
    if ft == "html" or ft == "htmldjango" then
      vim.opt_local.indentexpr = ""
    end
  end,
})
