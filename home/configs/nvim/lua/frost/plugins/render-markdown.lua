-- ~/.config/nvim/lua/frost/plugins/ui/document.lua

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx", "codecompanion" },
    keys = {
      { "<leader>wmp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Preview Markdown Document" },
    },
    opts = {
      latex = {
        enabled = true,
        converter = "latex2text",
      },
    },
  },
}
