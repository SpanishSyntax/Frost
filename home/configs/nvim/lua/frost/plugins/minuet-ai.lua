return {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        provider = "gemini",
        provider_options = {
          gemini = {
            -- flash is highly optimized for ultra-low latency typing completions
            model = "gemini-2.5-flash",
            stream = true,
            api_key = "GEMINI_API_KEY",
          },
        },
        virtual_text = {
          auto_trigger_ft = { "*" }, -- Trigger globally across all file types
          keymap = {
            accept = "<Tab>", -- Tab to accept completion
            dismiss = "<A-e>", -- Alt+e to clear the ghost text
          },
        },
      })
    end,
  },
}
