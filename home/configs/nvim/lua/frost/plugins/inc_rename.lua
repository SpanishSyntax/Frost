return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>cR",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Project LSP Rename (IncRename)",
      },
    },
    opts = {
      input_buffer_type = "snacks",
    },
  },
}
