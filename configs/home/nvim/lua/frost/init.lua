-- Frost Neovim Configuration (Starter / Template)
-- Custom plugins and user overrides live in your fleet's configs/home/nvim/

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 2
opt.expandtab = true
opt.termguicolors = true
opt.cursorline = true
opt.clipboard = "unnamedplus"

require("frost.lazy")
