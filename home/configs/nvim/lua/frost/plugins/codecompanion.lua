-- ~/.config/nvim/lua/frost/plugins/ai/codecompanion.lua

return {
  "olimorris/codecompanion.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "ravitemer/mcphub.nvim",
  },
  keys = {
    {
      "<leader>aa",
      "<cmd>CodeCompanionActions<cr>",
      mode = { "n", "v" },
      desc = "AI Actions / Agents",
    },
    {
      "<leader>ac",
      "<cmd>CodeCompanionChat toggle<cr>",
      mode = { "n", "v" },
      desc = "Toggle AI Chat Drawer",
    },
    {
      "<leader>ae",
      "<cmd>CodeCompanionChat Add<cr>",
      mode = "v",
      desc = "Add Visual Context to Chat",
    },
    { "<leader>ai", ":<C-u>CodeCompanion ", mode = "v", desc = "Inline AI Transformation Prompt" },
  },
  opts = {
    display = {
      chat = {
        window = { layout = "vertical", width = 45, border = "rounded" },
      },
      inline = { layout = "vertical" },
    },

    strategies = {
      chat = {
        adapter = "gemini",
        variables = {
          ["buffer"] = {
            callback = function()
              return require("codecompanion.strategies.chat.variables.buffer")
            end,
          },
          ["file"] = {
            callback = function()
              return require("codecompanion.strategies.chat.variables.file")
            end,
          },
          ["mcp"] = {
            callback = function()
              local ok, ext = pcall(require, "mcphub.extensions.codecompanion.variables")
              return ok and ext or nil
            end,
          },
        },
      },
      inline = {
        adapter = "gemini",
        keymaps = {
          accept_change = { modes = { n = "ga" }, desc = "Accept inline AI change" },
          reject_change = { modes = { n = "gr" }, desc = "Reject inline AI change" },
        },
      },
      agent = {
        adapter = "agy",
        tools = {
          ["mcp"] = {
            callback = function()
              local ok, tool = pcall(require, "mcphub.extensions.codecompanion.tools")
              return ok and tool or nil
            end,
          },
        },
      },
    },

    adapters = {
      -- Correct extension layout for native Gemini HTTP adapter
      gemini = function()
        return require("codecompanion.adapters").extend("gemini", {
          env = {
            api_key = "cmd:echo $GEMINI_API_KEY",
          },
          schema = {
            model = {
              default = "gemini-2.5-pro",
            },
          },
        })
      end,

      -- Native structural block configuration for the Agent Client Protocol (ACP)
      agy = function()
        return {
          name = "agy",
          formatted_name = "Google Antigravity Agent",
          type = "acp",
          commands = {
            default = { "agy", "--acp" },
          },
          defaults = {
            timeout = 30000,
          },
        }
      end,
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
}
