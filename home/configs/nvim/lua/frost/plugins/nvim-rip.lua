return {
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>cr",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = "Buffer Replace (RipSubstitute)",
      },
    },
    opts = {
      popupWin = {
        title = " Replace ",
        border = "rounded",
        position = "bottom",
      },
    },
  },
}
