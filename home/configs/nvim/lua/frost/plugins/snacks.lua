local viewers = require("frost.tools.pdf_viewers")
local header_tool = require("frost.tools.dashboard_header")
local excludes = require("frost.configs.ignores").get_excludes()

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep Search",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bD",
      function()
        Snacks.bufdelete({ force = true })
      end,
      desc = "Force Delete Buffer",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "Find References (Snacks)",
    },
    {
      "<leader>st",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Floating Terminal",
    },
    {
      "<leader>sz",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>ss",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
  },
  opts = {
    animate = { enabled = true },
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = header_tool.ascii_header,
        keys = {
          {
            icon = " ",
            key = "f",
            desc = "Find File",
            action = function()
              Snacks.picker.files()
            end,
          },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          {
            icon = " ",
            key = "t",
            desc = "Find Text",
            action = function()
              Snacks.picker.grep()
            end,
          },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = function()
              Snacks.picker.recent()
            end,
          },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = header_tool.build_sections(),
    },

    explorer = {
      enabled = true,
      filters = {
        dotfiles = true,
        exclude = excludes,
      },
    },

    git = { enabled = true },
    image = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },

    picker = {
      enabled = true,
      sources = {
        files = {
          exclude = excludes,
        },
        grep = {
          exclude = excludes,
        },
        explorer = {
          hidden = true,
          ignored = true,
          exclude = excludes,
          win = {
            list = {
              keys = {
                ["gz"] = "open_zathura",
                ["gs"] = "open_sioyek",
                ["gS"] = "open_sioyek_reuse",
                ["fn"] = "flaker_new",
                ["fN"] = "flaker_lang_new",
              },
            },
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<CR>"] = { "smart_confirm", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        flaker_new = function()
          require("frost.tools.flaker").writing_new()
        end,

        flaker_lang_new = function()
          require("frost.tools.flaker").lang_new()
        end,

        smart_confirm = function(picker, item)
          item = item or picker:current()
          if not item then
            return picker:action("confirm")
          end

          local path = Snacks.picker.util.path(item)
          if not path then
            return picker:action("confirm")
          end

          local ext = vim.fn.fnamemodify(path, ":e"):lower()
          local external_bin = viewers.external_openers[ext]

          if external_bin then
            picker:close()
            viewers.open(external_bin, path, { new_instance = true })
          else
            picker:action("confirm")
          end
        end,

        open_zathura = function(picker)
          local item = picker:current()
          local path = item and Snacks.picker.util.path(item)
          if path then
            viewers.open("zathura", path)
          end
        end,

        open_sioyek = function(picker)
          local item = picker:current()
          local path = item and Snacks.picker.util.path(item)
          if path then
            viewers.open("sioyek", path, { new_instance = true })
          end
        end,

        open_sioyek_reuse = function(picker)
          local item = picker:current()
          local path = item and Snacks.picker.util.path(item)
          if path then
            viewers.open("sioyek", path, { new_instance = false })
          end
        end,
      },
    },

    profiler = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = {
      enabled = true,
      win = {
        position = "float",
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
    toggle = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  },
}
