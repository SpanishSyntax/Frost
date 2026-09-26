return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,

    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        -- Systems & Compiled Languages
        "c",
        "cpp",
        "go",
        "java",
        "rust",

        -- Data & Scientific
        "julia",
        "python",

        -- Web & Frontend Ecosystem
        "css",
        "html",
        "javascript",
        "svelte",
        "tsx",
        "typescript",
        "vue",

        -- Document & Typesetting Workspaces
        "bibtex",
        "latex",
        "markdown",
        "markdown_inline",
        "mermaid",
        "typst",

        -- Configuration, Scripting & Data Formats
        "bash",
        "nginx",
        "diff",
        "dockerfile",
        "json",
        "lua",
        "nix",
        "regex",
        "ron",
        "toml",
        "yaml",
      },
      auto_install = true,
    },
  },
}
