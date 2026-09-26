-- ~/.config/nvim/lua/frost/core.lua

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.expandtab = true
opt.termguicolors = true
opt.cursorline = true
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.ignorecase = true -- Case insensitive searching
opt.smartcase = true -- ... until you use a capital letter
opt.updatetime = 250 -- Faster completion/indexing
opt.timeoutlen = 300 -- Faster Which-Key popup
opt.hlsearch = true
