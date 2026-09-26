-- ~/.config/nvim/lua/frost/plugins/lsp/blink.lua

return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    build = "cargo build --release", -- CRITICAL FOR NIX
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      keymap = {
        preset = "default",
        ["K"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-u>"] = { "scroll_signature_up", "fallback" },
        ["<C-d>"] = { "scroll_signature_down", "fallback" },
      },
      completion = {
        keyword = { range = "full" },
        accept = { auto_brackets = { enabled = false } },
        list = { selection = { preselect = true, auto_insert = false } },
        menu = {
          auto_show = true,
          border = "rounded",
        },
        documentation = {
          auto_show = true,
          window = { border = "rounded" },
        },
        ghost_text = { enabled = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = { preset = "luasnip" },
    },
  },
}
