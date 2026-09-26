return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    keys = {
      {
        "<leader>cr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Incremental Rename",
      },
    },
    opts = {
      input_buffer_type = "snacks",
    },
  },
}
