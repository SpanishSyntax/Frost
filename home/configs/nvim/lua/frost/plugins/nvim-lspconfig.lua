-- ~/.config/nvim/lua/frost/plugins/lsp/nvim-lspconfig.lua

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo" },

    dependencies = {
      "saghen/blink.cmp",
    },

    keys = {
      -- ------------------------------------------------------------
      -- 1. LSP Navigation & Information (Standard Mappings)
      -- ------------------------------------------------------------
      { "gd", vim.lsp.buf.definition, desc = "Go to Definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Go to Declaration" },
      { "gi", vim.lsp.buf.implementation, desc = "Go to Implementation" },
      { "gt", vim.lsp.buf.type_definition, desc = "Go to Type Definition" },

      -- ------------------------------------------------------------
      -- 3. Diagnostics & Error Handling Inline Overlays
      -- ------------------------------------------------------------
      { "<leader>cd", vim.diagnostic.open_float, desc = "Line Diagnostics Modal" },
      {
        "[d",
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end,
        desc = "Previous Diagnostic",
      },
      {
        "]d",
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end,
        desc = "Next Diagnostic",
      },

      -- ------------------------------------------------------------
      -- 4. UI Layer / Workspace Feature Toggles (<leader>u)
      -- ------------------------------------------------------------
      {
        "<leader>uh",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
        end,
        desc = "Toggle Inlay Hints",
      },
    },

    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        float = {
          border = "rounded",
          source = "if_many",
        },
      })

      local servers = {
        -- ------------------------------------------------------------
        -- Systems & Compiled Languages
        -- ------------------------------------------------------------
        clangd = { filetypes = { "c", "cpp" } },
        jdtls = {},
        gopls = {
          filetypes = { "go" },
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
              },
            },
          },
        },
        rust_analyzer = {
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },

        -- ------------------------------------------------------------
        -- Data & Scientific
        -- ------------------------------------------------------------
        ruff = { filetypes = { "python" } },
        ty = {
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_markers = { "pyproject.toml", "setup.py", ".git" },
        },
        julials = { filetypes = { "julia" } },

        -- ------------------------------------------------------------
        -- Web & Frontend Ecosystem
        -- ------------------------------------------------------------
        vtsls = {
          filetypes = {
            "javascript",
            "typescript",
            "typescriptreact",
          },
        },
        svelte = {},
        volar = {},

        -- ------------------------------------------------------------
        -- Document & Typesetting Workspaces
        -- ------------------------------------------------------------
        marksman = { filetypes = { "markdown" } },
        tinymist = {
          filetypes = { "typst" },
          settings = {
            exportPdf = "onSave",
            semanticTokens = "enable",
            formatterMode = "typstyle",
            rootPath = os.getenv("TYPST_ROOT") or nil,
          },
        },
        texlab = {
          settings = {
            texlab = {
              filetypes = { "tex" },
              settings = {
                texlab = {
                  formatterLineLength = 80,
                  bibtexFormatter = "texlab",
                  latexFormatter = "texlab",
                },
              },
            },
          },
        },

        -- ------------------------------------------------------------
        -- Configuration, Scripting & Data Formats
        -- ------------------------------------------------------------
        nixd = { filetypes = { "nix" } },
        bashls = { filetypes = { "sh", "bash" } },
        dockerls = { filetypes = { "dockerfile" } },
        docker_compose_language_service = { filetypes = { "yaml.docker-compose" } },
        qmlls = { filetypes = { "ini", "qml" } },
        taplo = {},
        yamlls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              hint = { enable = true },
            },
          },
        },
      }

      for name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})

        vim.lsp.config(name, cfg)
      end

      local group = vim.api.nvim_create_augroup("FrostLsp", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          for server, cfg in pairs(servers) do
            if vim.tbl_contains(cfg.filetypes or {}, args.match) then
              vim.lsp.enable(server)
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, {
              bufnr = args.buf,
            })
          end
        end,
      })
    end,
    -- Auto-configure and register every server with Blink capabilities
    -- 1. Inject Blink capabilities into ALL language servers globally
    --   vim.lsp.config("*", {
    --     capabilities = capabilities,
    --   })
    --
    --   -- 2. Register configs and auto-enable them for their filetypes
    --   for name, cfg in pairs(servers) do
    --     vim.lsp.config(name, cfg)
    --     vim.lsp.enable(name)
    --   end
    --
    --   -- Automatic Inlay Hints attachment on support
    --   local group = vim.api.nvim_create_augroup("FrostLsp", { clear = true })
    --   vim.api.nvim_create_autocmd("LspAttach", {
    --     group = group,
    --     callback = function(args)
    --       local client = vim.lsp.get_client_by_id(args.data.client_id)
    --       if client and client:supports_method("textDocument/inlayHint") then
    --         vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    --       end
    --     end,
    --   })
    -- end,
  },
}
