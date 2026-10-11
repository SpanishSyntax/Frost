return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      win = { border = "rounded" },
      spec = {
        { "<leader>f", group = "File/Search", icon = "󰈔 " },
        { "<leader>c", group = "Code", icon = " " },
        { "<leader>b", group = "Buffer", icon = " " },
        { "<leader>g", group = "Git", icon = "󰊢 " },
        { "<leader>a", group = "AI/Agents", icon = "󱚣 " },
        { "<leader>u", group = "UI/Toggles", icon = "󰔎 " },
        { "<leader>k", group = "Docker/Containers", icon = " " },
        { "<leader>m", group = "Jupyter Notebooks (Molten)", icon = "󰗊 " }, -- or " " for Python/Data
        { "<leader>w", group = "Writing", icon = "󱓧 " },
      },
    },
  },
}
