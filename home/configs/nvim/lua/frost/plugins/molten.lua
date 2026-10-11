return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- recommended by the molten docs
    build = ":UpdateRemotePlugins",
    dependencies = {
      -- Crucial for rendering those beautiful Mathvis/Julia plots directly in Neovim
      "3rd/image.nvim",
    },
    init = function()
      -- Molten is configured via global variables before the plugin loads
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", desc = "Molten: Initialize", silent = true },
      {
        "<leader>me",
        ":MoltenEvaluateOperator<CR>",
        desc = "Molten: Evaluate Operator",
        silent = true,
      },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Molten: Evaluate Line", silent = true },
      {
        "<leader>mc",
        ":MoltenReevaluateCell<CR>",
        desc = "Molten: Re-evaluate Cell",
        silent = true,
      },
      { "<leader>md", ":MoltenDelete<CR>", desc = "Molten: Delete Output", silent = true },
      { "<leader>mo", ":MoltenShowOutput<CR>", desc = "Molten: Show Output", silent = true },
      {
        "<leader>mv",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        mode = "v",
        desc = "Molten: Evaluate Visual",
        silent = true,
      },
    },
  },
  {
    -- Configuration for the image rendering backend
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- Switch to "ueberzug" if you don't use Kitty or a Kitty-protocol compatible terminal
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
}
