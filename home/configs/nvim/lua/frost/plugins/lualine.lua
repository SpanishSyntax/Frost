return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "gruvbox",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },
}
