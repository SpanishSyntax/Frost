-- ~/.config/nvim/lua/frost/plugins/ui/document.lua

return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",

    keys = {
      { "<leader>wtp", "<cmd>TypstPreview<cr>", desc = "Typst: Live preview in browser" },
      { "<leader>wts", "<cmd>TypstPreviewStop<cr>", desc = "Typst: Stop live preview" },
      { "<leader>wtt", "<cmd>TypstPreviewToggle<cr>", desc = "Typst: Toggle live preview" },
      {
        "<leader>wti",
        "<cmd>TypstPreviewFollowCursorToggle<cr>",
        desc = "Typst: Toggle follow cursor",
      },
    },

    opts = {

      dependencies_bin = {
        tinymist = "tinymist",
      },

      debug = true,
      port = 9997,
      host = "127.0.0.1",
    },
  },
}
