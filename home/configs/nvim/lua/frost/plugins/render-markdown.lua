-- ~/.config/nvim/lua/frost/plugins/ui/document.lua

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx", "codecompanion" },
    keys = {
      { "<leader>wmt", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: Toggle in-buffer render" },
    },
    opts = {
      latex = {
        enabled = true,
        converter = "latex2text",
      },
    },
  },
}
