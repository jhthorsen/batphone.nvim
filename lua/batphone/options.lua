local opt = vim.opt

opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.autoindent = true
opt.expandtab = true
opt.linebreak = true
opt.smartindent = true
opt.wrap = false

opt.mouse = ""
opt.background = "dark"
opt.cmdheight = 1
opt.cursorline = true
opt.colorcolumn = {80, 100}
opt.numberwidth = 4
opt.scrolloff = 8
opt.showtabline = 0

opt.hlsearch = false
opt.ignorecase = false
opt.incsearch = true
opt.number = true
opt.relativenumber = true
opt.ruler = false

opt.backup = false
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

opt.timeoutlen = 250
opt.swapfile = false
opt.undodir = os.getenv("HOME") .. "/.cache/nvim/undo"
opt.undofile = true

opt.signcolumn = "yes"
opt.virtualedit = "block"
opt.isfname:append("@-@")
opt.errorbells = false
opt.foldenable = false
opt.lazyredraw = true
opt.showcmd = false
opt.showmode = false
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.wildmenu = true
opt.wildmode = { "longest:list", "full" }
