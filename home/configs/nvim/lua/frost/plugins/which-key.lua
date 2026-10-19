return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = "rounded" },
      spec = {
        -- Main Navigation Groups
        { "<leader>f", group = "File / Find", icon = "󰈔 " },
        { "<leader>c", group = "Code / LSP", icon = " " },
        { "<leader>b", group = "Buffer", icon = " " },
        { "<leader>g", group = "Git", icon = "󰊢 " },
        { "<leader>s", group = "Snacks / Search", icon = "󰛔 " },
        { "<leader>u", group = "UI / Toggles", icon = "󰔎 " },

        -- Writing & Documents
        { "<leader>w", group = "Writing", icon = "󱓧 " },
        { "<leader>wf", group = "Folio / Flaker", icon = "❄️ " },
        { "<leader>wm", group = "Markdown (Firn)", icon = " " },
        { "<leader>wt", group = "Typst Preview", icon = " " },
        { "<leader>wl", group = "LaTeX (VimTeX)", icon = "󰔄 " },

        -- Standalone Root Actions
        { "<leader>e", desc = "File Explorer (Snacks)", icon = "󰙅 " },
        { "<leader>z", desc = "Zen Mode (Snacks)", icon = "󱓡 " },
        { "<leader>S", desc = "Scratch Buffer (Snacks)", icon = "󱞩 " },
        { "<leader>L", desc = "Lazy Plugin Manager", icon = "󰒲 " },
        { "<leader>q", desc = "Quit Neovim", icon = " " },
      },
    },
  },
}
