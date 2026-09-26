return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>go", "<cmd>DiffviewOpen<cr>", desc = "Git: Open Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: File History" },
    },
  },
}
