return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      terminal_colors = true,
      undercurl = true,
      underline = true,
      bold = false,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      inverse = true,
      contrast = "",
      palette_overrides = {},
      overrides = {},
      dim_inactive = false,
      transparent_mode = true,
    },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      vim.cmd.colorscheme("gruvbox")

      vim.api.nvim_set_hl(0, "Pmenu", {
        bg = "none",
      })
    end,
  },
}
