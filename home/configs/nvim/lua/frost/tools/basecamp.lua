-- lua/frost/tools/basecamp.lua
local common = require("frost.tools.common")
local M = {}

-- ===================================================================
-- Helpers
-- ===================================================================

local function run_interactive(cmd, cwd, title, target_file, opts)
  title = title and ("❄️ " .. title) or "❄️ Basecamp"
  common.run_interactive(cmd, cwd, title, target_file, opts)
end

-- ===================================================================
-- 1. Writing & Documents Dispatchers (<leader>Bw... and <leader>wk...)
-- ===================================================================

--- Workspace Initialization for Writing (<leader>Bwi, <leader>wki)
function M.writing_init()
  local doc = common.get_active_doc()
  local items = {
    {
      label = "󱓷 Snowpack Paper",
      cmd = { "basecamp", "init", "snowpack", "paper" },
      file = "paper.md",
    },
    {
      label = "󱓷 Snowpack Report",
      cmd = { "basecamp", "init", "snowpack", "report" },
      file = "report.md",
    },
    {
      label = "󱓷 Snowpack Slides",
      cmd = { "basecamp", "init", "snowpack", "slides" },
      file = "slides.md",
    },
    { label = "󰬛 Native Typst Paper", cmd = { "basecamp", "init", "typ:paper" }, file = "paper.typ" },
    { label = "󰬛 Native Typst Report", cmd = { "basecamp", "init", "typ:report" }, file = "report.typ" },
    { label = " Native LaTeX Paper", cmd = { "basecamp", "init", "tex:paper" }, file = "paper.tex" },
    { label = " Native LaTeX Report", cmd = { "basecamp", "init", "tex:report" }, file = "report.tex" },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Full Setup: Writing",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Project Foundations for Writing (<leader>Bwp, <leader>wkp)
function M.writing_project()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Snowpack Paper", cmd = { "basecamp", "project", "snowpack:paper" } },
    { label = "󱓷 Snowpack Report", cmd = { "basecamp", "project", "snowpack:report" } },
    { label = "󱓷 Snowpack Slides", cmd = { "basecamp", "project", "snowpack:slides" } },
    { label = "󰬛 Typst Configs", cmd = { "basecamp", "project", "typ" } },
    { label = " LaTeX Configs", cmd = { "basecamp", "project", "tex" } },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Project Configs: Writing",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Generate Snowpack DevShell Only (<leader>Bws, <leader>wks)
function M.writing_shell()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Snowpack DevShell", cmd = { "basecamp", "shell", "snowpack" }, file = "flake.nix" },
    { label = "󰬛 Typst DevShell", cmd = { "basecamp", "shell", "typ" }, file = "flake.nix" },
    { label = " LaTeX DevShell", cmd = { "basecamp", "shell", "tex" }, file = "flake.nix" },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Add DevShell: Writing",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Dedicated Starter Documents Generator (<leader>Bwn, <leader>Bn)
--- (3 formats: md, typ, tex × 3 templates: report, slides, paper = 9 combinations)
function M.writing_new()
  local ctx = common.get_context_dir()
  local items = {
    -- Markdown Starters (md)
    { label = " Markdown Paper", cmd = { "basecamp", "new", "md:paper" }, file = "paper.md" },
    { label = " Markdown Report", cmd = { "basecamp", "new", "md:report" }, file = "report.md" },
    { label = " Markdown Slides", cmd = { "basecamp", "new", "md:slides" }, file = "slides.md" },

    -- Typst Starters (typ)
    { label = " Typst Paper", cmd = { "basecamp", "new", "typ:paper" }, file = "paper.typ" },
    { label = " Typst Report", cmd = { "basecamp", "new", "typ:report" }, file = "report.typ" },
    { label = " Typst Slides", cmd = { "basecamp", "new", "typ:slides" }, file = "slides.typ" },

    -- LaTeX Starters (tex)
    { label = " LaTeX Paper", cmd = { "basecamp", "new", "tex:paper" }, file = "paper.tex" },
    { label = " LaTeX Report", cmd = { "basecamp", "new", "tex:report" }, file = "report.tex" },
    { label = " LaTeX Slides", cmd = { "basecamp", "new", "tex:slides" }, file = "slides.tex" },
  }

  local prompt = "󱓷 New Document"
  if ctx.rel_dir and ctx.rel_dir ~= "./" then
    prompt = prompt .. " in " .. ctx.rel_dir
  end

  vim.ui.select(items, {
    prompt = prompt,
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, ctx.dir, choice.label, choice.file)
  end)
end

--- Package Configuration Dispatcher (<leader>BwP, <leader>wkP)
function M.writing_packages()
  local doc = common.get_active_doc()
  local is_tex = doc.ext == "tex"
  local is_typ = doc.ext == "typ"

  local items = {
    {
      label = (is_typ and "󰬛 " or " ")
        .. "Typst Packages (packages.typ)"
        .. (is_typ and " (Active)" or ""),
      cmd = { "basecamp", "packages", "typ" },
      file = "packages.typ",
    },
    {
      label = (is_tex and " " or " ")
        .. "LaTeX Packages (packages.tex)"
        .. (is_tex and " (Active)" or ""),
      cmd = { "basecamp", "packages", "tex" },
      file = "packages.tex",
    },
  }

  -- Prioritize active buffer's document format
  if is_tex then
    table.sort(items, function(a, b)
      return a.cmd[3] == "tex"
    end)
  elseif is_typ then
    table.sort(items, function(a, b)
      return a.cmd[3] == "typ"
    end)
  end

  vim.ui.select(items, {
    prompt = "󱓷 Packages",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

-- ===================================================================
-- 2. Programming Languages & Stacks Dispatchers (<leader>Bl...)
-- ===================================================================

--- Language Workspace Initialization (<leader>Bli)
function M.lang_init()
  local doc = common.get_active_doc()
  local items = {
    -- Data & Scientific
    { label = " Python (uv + ruff)", cmd = { "basecamp", "init", "py" }, file = "pyproject.toml" },
    {
      label = "󰦨 MathVis (Simulation stack)",
      cmd = { "basecamp", "init", "mv" },
      file = "plot.py",
    },
    { label = " Julia", cmd = { "basecamp", "init", "julia" }, file = "Project.toml" },

    -- Systems
    {
      label = " Rust (Cargo + rust-analyzer)",
      cmd = { "basecamp", "init", "rust" },
      file = "Cargo.toml",
    },
    { label = " Go (gopls + delve)", cmd = { "basecamp", "init", "go" }, file = "go.mod" },
    {
      label = " C / C++ (clangd + cmake)",
      cmd = { "basecamp", "init", "cpp" },
      file = "CMakeLists.txt",
    },
    { label = " Zig (zls)", cmd = { "basecamp", "init", "zig" }, file = "build.zig" },
    { label = "󰌛 .NET / C# (.NET 9)", cmd = { "basecamp", "init", "dotnet" } },
    { label = " Java (OpenJDK 25)", cmd = { "basecamp", "init", "java" } },

    -- Web & Frontend
    {
      label = " TypeScript (Bun + vtsls)",
      cmd = { "basecamp", "init", "ts" },
      file = "package.json",
    },
    {
      label = "󰄛 Next.js (Bun + vtsls)",
      cmd = { "basecamp", "init", "next" },
      file = "package.json",
    },
    {
      label = " Svelte (Svelte 5)",
      cmd = { "basecamp", "init", "svelte" },
      file = "package.json",
    },
    { label = "󰡄 Vue (Vue 3)", cmd = { "basecamp", "init", "vue" }, file = "package.json" },

    -- Functional
    {
      label = " Elixir (Mix + elixir-ls)",
      cmd = { "basecamp", "init", "elixir" },
      file = "mix.exs",
    },
    { label = " Gleam (rebar3)", cmd = { "basecamp", "init", "gleam" }, file = "gleam.toml" },
    { label = " Haskell (GHC + Cabal + HLS)", cmd = { "basecamp", "init", "haskell" } },

    -- DevOps & Cloud
    {
      label = "󰡨 DevOps (Compose + Lazydocker)",
      cmd = { "basecamp", "init", "ops" },
      file = "compose.yaml",
    },
  }

  vim.ui.select(items, {
    prompt = " Full Setup: Languages",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Project Foundation Files (<leader>Blp)
function M.lang_project()
  local doc = common.get_active_doc()
  local items = {
    {
      label = " Python (pyproject.toml)",
      cmd = { "basecamp", "project", "py" },
      file = "pyproject.toml",
    },
    { label = " Rust (Cargo.toml)", cmd = { "basecamp", "project", "rust" }, file = "Cargo.toml" },
    { label = " Go (go.mod)", cmd = { "basecamp", "project", "go" }, file = "go.mod" },
    {
      label = " TypeScript (package.json)",
      cmd = { "basecamp", "project", "ts" },
      file = "package.json",
    },
    {
      label = " C++ (CMakeLists.txt)",
      cmd = { "basecamp", "project", "cpp" },
      file = "CMakeLists.txt",
    },
    { label = " Zig (build.zig)", cmd = { "basecamp", "project", "zig" }, file = "build.zig" },
    {
      label = " Julia (Project.toml)",
      cmd = { "basecamp", "project", "julia" },
      file = "Project.toml",
    },
    { label = " Elixir (mix.exs)", cmd = { "basecamp", "project", "elixir" }, file = "mix.exs" },
    {
      label = " Gleam (gleam.toml)",
      cmd = { "basecamp", "project", "gleam" },
      file = "gleam.toml",
    },
    {
      label = "󰡨 DevOps (compose.yaml)",
      cmd = { "basecamp", "project", "ops" },
      file = "compose.yaml",
    },
  }

  vim.ui.select(items, {
    prompt = " Project Configs",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Drop Language Starter Files (<leader>Bln)
function M.lang_new()
  local ctx = common.get_context_dir()
  local items = {
    { label = " Python (main.py)", cmd = { "basecamp", "new", "py" }, file = "main.py" },
    { label = "󰦨 MathVis (plot.py)", cmd = { "basecamp", "new", "mv" }, file = "plot.py" },
    { label = " Rust (src/main.rs)", cmd = { "basecamp", "new", "rust" }, file = "src/main.rs" },
    { label = " Go (main.go)", cmd = { "basecamp", "new", "go" }, file = "main.go" },
    { label = " TypeScript (index.ts)", cmd = { "basecamp", "new", "ts" }, file = "index.ts" },
    { label = " C++ (main.cpp)", cmd = { "basecamp", "new", "cpp" }, file = "main.cpp" },
    { label = " Zig (src/main.zig)", cmd = { "basecamp", "new", "zig" }, file = "src/main.zig" },
    { label = " Julia (main.jl)", cmd = { "basecamp", "new", "julia" }, file = "main.jl" },
    {
      label = " Elixir (lib/main.ex)",
      cmd = { "basecamp", "new", "elixir" },
      file = "lib/main.ex",
    },
    {
      label = " Gleam (src/main.gleam)",
      cmd = { "basecamp", "new", "gleam" },
      file = "src/main.gleam",
    },
    {
      label = " Haskell (app/Main.hs)",
      cmd = { "basecamp", "new", "haskell" },
      file = "app/Main.hs",
    },
  }

  local prompt = " New Starter File"
  if ctx.rel_dir and ctx.rel_dir ~= "./" then
    prompt = prompt .. " in " .. ctx.rel_dir
  end

  vim.ui.select(items, {
    prompt = prompt,
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, ctx.dir, choice.label, choice.file)
  end)
end

--- Generate Language DevShell Only (<leader>Bls)
function M.lang_shell()
  local doc = common.get_active_doc()
  local items = {
    {
      label = " Python (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "py" },
      file = "flake.nix",
    },
    {
      label = " Rust (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "rust" },
      file = "flake.nix",
    },
    {
      label = " Go (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "go" },
      file = "flake.nix",
    },
    {
      label = " TypeScript (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "ts" },
      file = "flake.nix",
    },
    {
      label = " C++ (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "cpp" },
      file = "flake.nix",
    },
    {
      label = " Zig (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "zig" },
      file = "flake.nix",
    },
    {
      label = " Julia (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "julia" },
      file = "flake.nix",
    },
    {
      label = "󰡨 DevOps (flake.nix + .envrc)",
      cmd = { "basecamp", "shell", "ops" },
      file = "flake.nix",
    },
    { label = "❄️ Interactive", cmd = { "basecamp", "shell" }, file = "flake.nix" },
  }

  vim.ui.select(items, {
    prompt = " Add DevShell",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

-- ===================================================================
-- 3. Universal & Meta Commands
-- ===================================================================

--- Interactive Stack Wizard & Role Selector (<leader>Bk, <leader>wkk)
function M.interactive()
  local doc = common.get_active_doc()
  run_interactive({ "basecamp", "interactive" }, doc.dir, "Basecamp Stack Selector")
end

--- List Registered Language Roles & Stacks (<leader>BL, <leader>Bll)
function M.list()
  local doc = common.get_active_doc()
  run_interactive({ "basecamp", "list" }, doc.dir, "Basecamp Roles", nil, {
    interactive = false,
    auto_close = false,
  })
end

--- Diagnose and List Active Roles on Workspace Flake (<leader>BA, <leader>Ba, <leader>Bla)
function M.active()
  local doc = common.get_active_doc()
  run_interactive({ "basecamp", "active" }, doc.dir, "Basecamp Active Roles", nil, {
    interactive = false,
    auto_close = false,
  })
end

M.list_active = M.active

-- Backward compatibility aliases
M.init = M.writing_init
M.project = M.writing_project
M.scaffold = M.writing_project
M.new = M.writing_new
M.shell = M.writing_shell
M.packages = M.writing_packages

-- ===================================================================
-- Keymaps
-- ===================================================================

-- -------------------------------------------------------------------
-- A. Basecamp Top-Level Palette (<leader>B...)
-- -------------------------------------------------------------------

-- Root Shortcuts
vim.keymap.set("n", "<leader>BI", function()
  M.interactive()
end, { desc = "Interactive" })
vim.keymap.set("n", "<leader>BL", function()
  M.list()
end, { desc = "List roles & stacks" })
vim.keymap.set("n", "<leader>BA", function()
  M.active()
end, { desc = "List active roles" })
vim.keymap.set("n", "<leader>BN", function()
  M.writing_new()
end, { desc = "New starter doc" })

-- Submenu 1: Programming Languages & Stacks (<leader>Bl...)
vim.keymap.set("n", "<leader>Bli", function()
  M.lang_init()
end, { desc = "Full setup (init)" })
vim.keymap.set("n", "<leader>Blp", function()
  M.lang_project()
end, { desc = "Project configs" })
vim.keymap.set("n", "<leader>Bln", function()
  M.lang_new()
end, { desc = "New starter file" })
vim.keymap.set("n", "<leader>Bls", function()
  M.lang_shell()
end, { desc = "Add flake and .envrc" })
vim.keymap.set("n", "<leader>Bll", function()
  M.list()
end, { desc = "List roles & stacks" })
vim.keymap.set("n", "<leader>Bla", function()
  M.active()
end, { desc = "List active roles" })

-- Submenu 2: Writing & Documents (<leader>Bw...)
vim.keymap.set("n", "<leader>Bwi", function()
  M.writing_init()
end, { desc = "Full setup (init)" })
vim.keymap.set("n", "<leader>Bwp", function()
  M.writing_project()
end, { desc = "Project configs" })
vim.keymap.set("n", "<leader>Bwn", function()
  M.writing_new()
end, { desc = "New starter doc" })
vim.keymap.set("n", "<leader>Bws", function()
  M.writing_shell()
end, { desc = "Add flake and .envrc" })
vim.keymap.set("n", "<leader>BwP", function()
  M.writing_packages()
end, { desc = "Configure packages" })

return M
