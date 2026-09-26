return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.surround").setup()
      require("mini.pairs").setup()

      -- Set up icons and mock nvim-web-devicons so other plugins route through Mini
      local icons = require("mini.icons")
      icons.setup({ style = "glyph" })
      icons.tweak_lsp_kind()

      -- Force fallback wrapper support for legacy plugins
      icons.mock_nvim_web_devicons()
    end,
  },
}
