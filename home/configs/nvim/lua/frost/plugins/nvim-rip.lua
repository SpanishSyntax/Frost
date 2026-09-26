return {
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>sr",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = "Rip Substitute",
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
