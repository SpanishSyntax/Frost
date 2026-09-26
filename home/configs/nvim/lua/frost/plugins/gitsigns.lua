return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
        end

        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle Blame")
      end,
    },
  },
}
