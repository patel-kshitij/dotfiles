local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.splitbelow = true
opt.splitright = true
opt.confirm = true
opt.laststatus = 3 -- one global statusline

-- Indentation (formatters override per-language on save)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"

-- Files
opt.undofile = true
opt.swapfile = false
opt.updatetime = 250
opt.timeoutlen = 400

-- Folding via treesitter, all open by default
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldtext = ""

opt.completeopt = "menu,menuone,noselect"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
