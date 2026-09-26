-- ~/.config/nvim/lua/frost/plugins/ai/mcphub.lua

return {
  "ravitemer/mcphub.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  build = nil,

  keys = {
    { "<leader>am", "<cmd>MCPHub<cr>", desc = "Open MCP Hub Manager Dashboard" },
  },
  opts = {
    use_bundled_binary = false,
    cmd = "mcp-hub",
    shutdown_delay = 5000,
  },
}
