-- ~/.config/nvim/lua/frost/plugins/lsp/formatting.lua

return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = { "ConformInfo" },
    -- Native atomized execution binding hook
    keys = {
      {
        "cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        desc = "Format Buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- ------------------------------------------------------------
        -- Systems & Compiled Languages
        -- ------------------------------------------------------------
        rust = { "rustfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        go = { "goimports", "gofmt" },
        java = { "google-java-format" },

        -- ------------------------------------------------------------
        -- Data & Scientific
        -- ------------------------------------------------------------
        python = { "ruff_format" },
        julia = { "julia-formatter" },

        -- ------------------------------------------------------------
        -- Web & Frontend Ecosystem
        -- ------------------------------------------------------------
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        svelte = { "prettierd" },
        vue = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },

        -- ------------------------------------------------------------
        -- Document & Typesetting Workspaces
        -- ------------------------------------------------------------
        typst = { "typstyle" },
        tex = { "latexindent" },
        bib = { "latexindent" },
        plaintex = { "latexindent" },
        markdown = { "prettierd" },

        -- ------------------------------------------------------------
        -- Configuration, Scripting & Data Formats
        -- ------------------------------------------------------------
        nix = { "alejandra" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        toml = { "taplo" },
        yaml = { "prettierd" },
        json = { "prettierd" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = { "--style={IndentWidth: 4, ColumnLimit: 100}" },
        },
        ["stylua"] = {
          prepend_args = {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
            "--column-width",
            "100",
            "--quote-style",
            "AutoPreferDouble",
          },
        },
        ["shfmt"] = {
          prepend_args = { "-i", "2", "-ci" },
        },
      },
      format_on_save = false, -- Absolute manual keymap control via 'cf'
    },
  },
}
