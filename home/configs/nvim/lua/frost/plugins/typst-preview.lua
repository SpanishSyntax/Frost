-- ~/.config/nvim/lua/frost/plugins/ui/document.lua

return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",

    keys = {
      { "<leader>wtp", "<cmd>TypstPreview<cr>", desc = "Typst Live Preview" },
      { "<leader>wts", "<cmd>TypstPreviewStop<cr>", desc = "Stop Typst Preview" },
      { "<leader>wtt", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
      { "<leader>wti", "<cmd>TypstPreviewFollowCursorToggle<cr>", desc = "Toggle Follow Cursor" },
    },

    opts = {
      open_cmd = "zen-twilight %s",

      dependencies_bin = {
        tinymist = "tinymist",
      },

      debug = true,
      port = 9997,
      host = "127.0.0.1",
    },
  },
}
