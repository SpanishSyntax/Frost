-- ~/.config/nvim/lua/frost/plugins/ui/document.lua

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx", "codecompanion" },
    keys = {
      { "<leader>wmt", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle In-Buffer Markdown Render" },
    },
    opts = {
      latex = {
        enabled = true,
        converter = "latex2text",
      },
    },
  },
}
