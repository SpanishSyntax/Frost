return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      views = {
        split = {
          backend = "split",
          enter = false,
          relative = "editor",
          position = "right",
          size = "50%",
        },
      },
      presets = {
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
}
