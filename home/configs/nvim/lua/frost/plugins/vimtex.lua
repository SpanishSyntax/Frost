return {
  {
    "lervag/vimtex",
    lazy = false,

    init = function()
      vim.g.vimtex_compiler_method = "tectonic"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_compiler_tectonic = {
        options = {
          "--synctex",
          "--keep-logs",
          "-Z",
          "continue-on-errors",
        },
      }
    end,

    keys = {
      {
        "<leader>wlp",
        "<cmd>VimtexView<cr>",
        desc = "Preview LaTeX Document",
      },
      {
        "<leader>wlc",
        "<cmd>VimtexCompile<cr>",
        desc = "Compile/Watch LaTeX",
      },
    },
  },
}
