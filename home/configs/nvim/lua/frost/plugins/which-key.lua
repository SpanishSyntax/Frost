return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = "rounded" },
      icons = {
        rules = {
          { pattern = "flaker", icon = "❄️ " },
          { pattern = "folio", icon = "󱓷 " },
          { pattern = "typst", icon = "󰬛 " },
          { pattern = "latex", icon = " " },
          { pattern = "markdown", icon = " " },
          { pattern = "firn", icon = " " },
          { pattern = "pdf", icon = "󰈦 " },
        },
      },
      spec = {
        -- Main Navigation Groups
        { "<leader>f", group = "Find", icon = "󰈔 " },
        { "<leader>c", group = "Code", icon = " " },
        { "<leader>b", group = "Buffer", icon = " " },
        { "<leader>g", group = "Git", icon = "󰊢 " },
        { "<leader>s", group = "Snacks", icon = "󱐋 " },
        { "<leader>u", group = "UI", icon = "󰔎 " },

        -- Writing & Documents
        { "<leader>w", group = "Writing", icon = "󱓧 " },
        { "<leader>wf", group = "Folio", icon = "󱓷 " },
        { "<leader>wk", group = "Flaker", icon = "❄️ " },
        { "<leader>wm", group = "Markdown", icon = " " },
        { "<leader>wt", group = "Typst", icon = "󰬛 " },
        { "<leader>wl", group = "LaTeX", icon = " " },

        -- Standalone Root Actions
        { "<leader>F", group = "Flaker", icon = "❄️ " },
        { "<leader>e", desc = "File Explorer", icon = "󰙅 " },
        { "<leader>L", desc = "Lazy", icon = "󰒲 " },
        { "<leader>q", desc = "Quit Neovim", icon = " " },
      },
    },
  },
}
