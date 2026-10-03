local viewers = require("frost.tools.pdf_viewers")

local external_openers = {
  pdf = "sioyek",
  epub = "sioyek",
}

-- Convert canonical ignores into Snacks glob exclusions
local snacks_excludes = {}

for _, dir in
  ipairs(vim.g.frost_ignore_directories or { ".git", ".direnv", ".venv", "node_modules" })
do
  table.insert(snacks_excludes, "**/" .. dir)
  table.insert(snacks_excludes, "**/" .. dir .. "/**")
end

for _, file in ipairs(vim.g.frost_ignore_files or { ".DS_Store", "Thumbs.db" }) do
  table.insert(snacks_excludes, "**/" .. file)
end

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
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>st",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Floating Terminal",
    },
    {
      "<leader>S",
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
    -- Efficient animations including over 45 easing functions. Trigger: Automatic
    animate = { enabled = true },

    -- Deal with big files. Trigger: Automatic upon opening large files
    bigfile = { enabled = true },

    -- Beautiful declarative dashboards. Trigger: Startup
    dashboard = {
      enabled = true,
      preset = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
        header = [[
 ███████╗██████╗  ██████╗ ███████╗████████╗
 ██╔════╝██╔══██╗██╔═══██╗██╔════╝╚══██╔══╝
 █████╗  ██████╔╝██║   ██║███████╗   ██║   
 ██╔══╝  ██╔══██╗██║   ██║╚════██║   ██║   
 ██║     ██║  ██║╚██████╔╝███████║   ██║   
 ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ]],
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
    },

    -- A file explorer (picker in disguise). Trigger: `<leader>e`
    explorer = {
      enabled = true,
      filters = {
        dotfiles = true,
        exclude = snacks_excludes,
      },
    },

    -- Git utilities. Trigger: Automatic
    git = { enabled = true },

    -- Image viewer using Kitty Graphics Protocol, supported by kitty, wezterm and ghostty. Trigger: Automatic
    image = { enabled = true },

    -- Indent guides and scopes. Trigger: Automatic
    indent = { enabled = true },

    -- Better vim.ui.input. Trigger: Automatic (e.g., LSP rename)
    input = { enabled = true },

    -- Pretty vim.notify. Trigger: `:lua Snacks.notifier.show_history()`
    notifier = { enabled = true },

    -- Picker for selecting items. Trigger: `<leader>ff`, `<leader>fg`, `<leader>fb`
    picker = {
      enabled = true,
      sources = {
        files = {
          exclude = snacks_excludes,
        },
        grep = {
          exclude = snacks_excludes,
        },
        explorer = {
          hidden = true,
          ignored = true,
          exclude = snacks_excludes,
          win = {
            list = {
              keys = {
                ["gz"] = "open_zathura",
                ["gs"] = "open_sioyek",
                ["gS"] = "open_sioyek_reuse",
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
          local external_bin = external_openers[ext]

          if external_bin then
            picker:close()
            -- Default: opens in a new instance/window
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

        -- Default: opens in a new instance/window
        open_sioyek = function(picker)
          local item = picker:current()
          local path = item and Snacks.picker.util.path(item)
          if path then
            viewers.open("sioyek", path, { new_instance = true })
          end
        end,

        -- Secondary: reuses current instance/window
        open_sioyek_reuse = function(picker)
          local item = picker:current()
          local path = item and Snacks.picker.util.path(item)
          if path then
            viewers.open("sioyek", path, { new_instance = false })
          end
        end,
      },
    },

    -- Neovim lua profiler. Trigger: `:lua Snacks.profiler.scratch()`
    profiler = { enabled = true },

    -- When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins. Trigger: Automatic
    quickfile = { enabled = true },

    -- Scope detection, text objects and jumping based on treesitter or indent. Trigger: Automatic
    scope = { enabled = true },

    -- Scratch buffers with a persistent file. Trigger: `<leader>S`
    scratch = { enabled = true },

    -- Smooth scrolling. Trigger: Automatic on scroll keys
    scroll = { enabled = true },

    -- Pretty status column. Trigger: Automatic
    statuscolumn = { enabled = true },

    -- Create and toggle floating/split terminals. Trigger: `<leader>st`
    terminal = {
      enabled = true,
      win = {
        position = "float",
        border = "rounded", -- Optional: adds rounded borders
        width = 0.8, -- 80% of screen width
        height = 0.8, -- 80% of screen height
      },
    },

    -- Toggle keymaps integrated with which-key icons / colors. Trigger: `:lua Snacks.toggle.*`
    toggle = { enabled = true },

    -- Auto-show LSP references and quickly navigate between them. Trigger: Automatic
    words = { enabled = true },

    -- Zen mode • distraction-free coding. Trigger: `<leader>z`
    zen = { enabled = true },
  },
}
