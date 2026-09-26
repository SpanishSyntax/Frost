-- ~/.config/nvim/lua/frost/keymaps.lua

local function map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = "Frost: " .. desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- =============================================================================
-- 1. General & Editor Mechanics (Pure Vanilla Core)
-- =============================================================================
map("n", "<leader>L", "<cmd>Lazy<cr>", "Lazy Menu")
map("n", "<leader>q", "<cmd>qa<cr>", "Quit All")
map("n", "<Esc>", "<cmd>noh<cr>", "Clear Highlights")

-- Window Navigation
map("n", "<C-h>", "<C-w>h", "Go to Left Window")
map("n", "<C-j>", "<C-w>j", "Go to Lower Window")
map("n", "<C-k>", "<C-w>k", "Go to Upper Window")
map("n", "<C-l>", "<C-w>l", "Go to Right Window")

-- Buffers Tabline Navigation
map("n", "<S-h>", "<cmd>bprevious<cr>", "Prev Buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next Buffer")
map("n", "<leader>bd", "<cmd>bd<cr>", "Delete Buffer")
