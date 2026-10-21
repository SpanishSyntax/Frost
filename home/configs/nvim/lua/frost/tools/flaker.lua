-- lua/frost/tools/flaker.lua
local common = require("frost.tools.common")
local M = {}

-- ===================================================================
-- Helpers
-- ===================================================================

local function run_interactive(cmd, cwd, title, target_file, opts)
  title = title and ("❄️ " .. title) or "❄️ Flaker"
  common.run_interactive(cmd, cwd, title, target_file, opts)
end

-- ===================================================================
-- 1. Writing & Documents Dispatchers (<leader>Fw... and <leader>wk...)
-- ===================================================================

--- Workspace Initialization for Writing (<leader>Fwi, <leader>wki)
function M.writing_init()
  local doc = common.get_active_doc()
  local items = {
    {
      label = "󱓷 Folio Paper",
      cmd = { "flaker", "init", "folio", "paper" },
      file = "paper.md",
    },
    {
      label = "󱓷 Folio Report",
      cmd = { "flaker", "init", "folio", "report" },
      file = "report.md",
    },
    {
      label = "󱓷 Folio Slides",
      cmd = { "flaker", "init", "folio", "slides" },
      file = "slides.md",
    },
    { label = "󰬛 Native Typst Paper", cmd = { "flaker", "init", "typ:paper" }, file = "paper.typ" },
    { label = "󰬛 Native Typst Report", cmd = { "flaker", "init", "typ:report" }, file = "report.typ" },
    { label = " Native LaTeX Paper", cmd = { "flaker", "init", "tex:paper" }, file = "paper.tex" },
    { label = " Native LaTeX Report", cmd = { "flaker", "init", "tex:report" }, file = "report.tex" },
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

--- Project Foundations for Writing (<leader>Fwp, <leader>wkp)
function M.writing_project()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Folio Paper", cmd = { "flaker", "project", "folio:paper" } },
    { label = "󱓷 Folio Report", cmd = { "flaker", "project", "folio:report" } },
    { label = "󱓷 Folio Slides", cmd = { "flaker", "project", "folio:slides" } },
    { label = "󰬛 Typst Configs", cmd = { "flaker", "project", "typ" } },
    { label = " LaTeX Configs", cmd = { "flaker", "project", "tex" } },
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

--- Generate Folio DevShell Only (<leader>Fws, <leader>wks)
function M.writing_shell()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Folio DevShell", cmd = { "flaker", "shell", "folio" }, file = "flake.nix" },
    { label = "󰬛 Typst DevShell", cmd = { "flaker", "shell", "typ" }, file = "flake.nix" },
    { label = " LaTeX DevShell", cmd = { "flaker", "shell", "tex" }, file = "flake.nix" },
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

--- Dedicated Starter Documents Generator (<leader>Fwn, <leader>Fn)
--- (3 formats: md, typ, tex × 3 templates: report, slides, paper = 9 combinations)
function M.writing_new()
  local ctx = common.get_context_dir()
  local items = {
    -- Markdown Starters (md)
    { label = " Markdown Paper", cmd = { "flaker", "new", "md:paper" }, file = "paper.md" },
    { label = " Markdown Report", cmd = { "flaker", "new", "md:report" }, file = "report.md" },
    { label = " Markdown Slides", cmd = { "flaker", "new", "md:slides" }, file = "slides.md" },

    -- Typst Starters (typ)
    { label = " Typst Paper", cmd = { "flaker", "new", "typ:paper" }, file = "paper.typ" },
    { label = " Typst Report", cmd = { "flaker", "new", "typ:report" }, file = "report.typ" },
    { label = " Typst Slides", cmd = { "flaker", "new", "typ:slides" }, file = "slides.typ" },

    -- LaTeX Starters (tex)
    { label = " LaTeX Paper", cmd = { "flaker", "new", "tex:paper" }, file = "paper.tex" },
    { label = " LaTeX Report", cmd = { "flaker", "new", "tex:report" }, file = "report.tex" },
    { label = " LaTeX Slides", cmd = { "flaker", "new", "tex:slides" }, file = "slides.tex" },
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

--- Package Configuration Dispatcher (<leader>FwP, <leader>wkP)
function M.writing_packages()
  local doc = common.get_active_doc()
  local is_tex = doc.ext == "tex"
  local is_typ = doc.ext == "typ"

  local items = {
    {
      label = (is_typ and "󰬛 " or " ")
        .. "Typst Packages (packages.typ)"
        .. (is_typ and " (Active)" or ""),
      cmd = { "flaker", "packages", "typ" },
      file = "packages.typ",
    },
    {
      label = (is_tex and " " or " ")
        .. "LaTeX Packages (packages.tex)"
        .. (is_tex and " (Active)" or ""),
      cmd = { "flaker", "packages", "tex" },
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
-- 2. Programming Languages & Stacks Dispatchers (<leader>Fl...)
-- ===================================================================

--- Language Workspace Initialization (<leader>Fli)
function M.lang_init()
  local doc = common.get_active_doc()
  local items = {
    -- Data & Scientific
    { label = " Python (uv + ruff)", cmd = { "flaker", "init", "py" }, file = "pyproject.toml" },
    {
      label = "󰦨 MathVis (Simulation stack)",
      cmd = { "flaker", "init", "mv" },
      file = "plot.py",
    },
    { label = " Julia", cmd = { "flaker", "init", "julia" }, file = "Project.toml" },

    -- Systems
    {
      label = " Rust (Cargo + rust-analyzer)",
      cmd = { "flaker", "init", "rust" },
      file = "Cargo.toml",
    },
    { label = " Go (gopls + delve)", cmd = { "flaker", "init", "go" }, file = "go.mod" },
    {
      label = " C / C++ (clangd + cmake)",
      cmd = { "flaker", "init", "cpp" },
      file = "CMakeLists.txt",
    },
    { label = " Zig (zls)", cmd = { "flaker", "init", "zig" }, file = "build.zig" },
    { label = "󰌛 .NET / C# (.NET 9)", cmd = { "flaker", "init", "dotnet" } },
    { label = " Java (OpenJDK 25)", cmd = { "flaker", "init", "java" } },

    -- Web & Frontend
    {
      label = " TypeScript (Bun + vtsls)",
      cmd = { "flaker", "init", "ts" },
      file = "package.json",
    },
    {
      label = "󰄛 Next.js (Bun + vtsls)",
      cmd = { "flaker", "init", "next" },
      file = "package.json",
    },
    {
      label = " Svelte (Svelte 5)",
      cmd = { "flaker", "init", "svelte" },
      file = "package.json",
    },
    { label = "󰡄 Vue (Vue 3)", cmd = { "flaker", "init", "vue" }, file = "package.json" },

    -- Functional
    {
      label = " Elixir (Mix + elixir-ls)",
      cmd = { "flaker", "init", "elixir" },
      file = "mix.exs",
    },
    { label = " Gleam (rebar3)", cmd = { "flaker", "init", "gleam" }, file = "gleam.toml" },
    { label = " Haskell (GHC + Cabal + HLS)", cmd = { "flaker", "init", "haskell" } },

    -- DevOps & Cloud
    {
      label = "󰡨 DevOps (Compose + Lazydocker)",
      cmd = { "flaker", "init", "ops" },
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

--- Project Foundation Files (<leader>Flp)
function M.lang_project()
  local doc = common.get_active_doc()
  local items = {
    {
      label = " Python (pyproject.toml)",
      cmd = { "flaker", "project", "py" },
      file = "pyproject.toml",
    },
    { label = " Rust (Cargo.toml)", cmd = { "flaker", "project", "rust" }, file = "Cargo.toml" },
    { label = " Go (go.mod)", cmd = { "flaker", "project", "go" }, file = "go.mod" },
    {
      label = " TypeScript (package.json)",
      cmd = { "flaker", "project", "ts" },
      file = "package.json",
    },
    {
      label = " C++ (CMakeLists.txt)",
      cmd = { "flaker", "project", "cpp" },
      file = "CMakeLists.txt",
    },
    { label = " Zig (build.zig)", cmd = { "flaker", "project", "zig" }, file = "build.zig" },
    {
      label = " Julia (Project.toml)",
      cmd = { "flaker", "project", "julia" },
      file = "Project.toml",
    },
    { label = " Elixir (mix.exs)", cmd = { "flaker", "project", "elixir" }, file = "mix.exs" },
    {
      label = " Gleam (gleam.toml)",
      cmd = { "flaker", "project", "gleam" },
      file = "gleam.toml",
    },
    {
      label = "󰡨 DevOps (compose.yaml)",
      cmd = { "flaker", "project", "ops" },
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

--- Drop Language Starter Files (<leader>Fln)
function M.lang_new()
  local ctx = common.get_context_dir()
  local items = {
    { label = " Python (main.py)", cmd = { "flaker", "new", "py" }, file = "main.py" },
    { label = "󰦨 MathVis (plot.py)", cmd = { "flaker", "new", "mv" }, file = "plot.py" },
    { label = " Rust (src/main.rs)", cmd = { "flaker", "new", "rust" }, file = "src/main.rs" },
    { label = " Go (main.go)", cmd = { "flaker", "new", "go" }, file = "main.go" },
    { label = " TypeScript (index.ts)", cmd = { "flaker", "new", "ts" }, file = "index.ts" },
    { label = " C++ (main.cpp)", cmd = { "flaker", "new", "cpp" }, file = "main.cpp" },
    { label = " Zig (src/main.zig)", cmd = { "flaker", "new", "zig" }, file = "src/main.zig" },
    { label = " Julia (main.jl)", cmd = { "flaker", "new", "julia" }, file = "main.jl" },
    {
      label = " Elixir (lib/main.ex)",
      cmd = { "flaker", "new", "elixir" },
      file = "lib/main.ex",
    },
    {
      label = " Gleam (src/main.gleam)",
      cmd = { "flaker", "new", "gleam" },
      file = "src/main.gleam",
    },
    {
      label = " Haskell (app/Main.hs)",
      cmd = { "flaker", "new", "haskell" },
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

--- Generate Language DevShell Only (<leader>Fls)
function M.lang_shell()
  local doc = common.get_active_doc()
  local items = {
    {
      label = " Python (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "py" },
      file = "flake.nix",
    },
    {
      label = " Rust (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "rust" },
      file = "flake.nix",
    },
    {
      label = " Go (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "go" },
      file = "flake.nix",
    },
    {
      label = " TypeScript (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "ts" },
      file = "flake.nix",
    },
    {
      label = " C++ (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "cpp" },
      file = "flake.nix",
    },
    {
      label = " Zig (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "zig" },
      file = "flake.nix",
    },
    {
      label = " Julia (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "julia" },
      file = "flake.nix",
    },
    {
      label = "󰡨 DevOps (flake.nix + .envrc)",
      cmd = { "flaker", "shell", "ops" },
      file = "flake.nix",
    },
    { label = "❄️ Interactive", cmd = { "flaker", "shell" }, file = "flake.nix" },
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

--- Interactive Stack Wizard & Role Selector (<leader>Fk, <leader>wkk)
function M.interactive()
  local doc = common.get_active_doc()
  run_interactive({ "flaker", "interactive" }, doc.dir, "Flaker Stack Selector")
end

--- List Registered Language Roles & Stacks (<leader>FL, <leader>Fll)
function M.list()
  local doc = common.get_active_doc()
  run_interactive({ "flaker", "list" }, doc.dir, "Flaker Roles", nil, {
    interactive = false,
    auto_close = false,
  })
end

--- Diagnose and List Active Roles on Workspace Flake (<leader>FA, <leader>Fa, <leader>Fla)
function M.active()
  local doc = common.get_active_doc()
  run_interactive({ "flaker", "active" }, doc.dir, "Flaker Active Roles", nil, {
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
-- A. Flaker Top-Level Palette (<leader>F...)
-- -------------------------------------------------------------------

-- Root Shortcuts
vim.keymap.set("n", "<leader>FI", function()
  M.interactive()
end, { desc = "Interactive" })
vim.keymap.set("n", "<leader>FL", function()
  M.list()
end, { desc = "List roles & stacks" })
vim.keymap.set("n", "<leader>FA", function()
  M.active()
end, { desc = "List active roles" })
vim.keymap.set("n", "<leader>FN", function()
  M.writing_new()
end, { desc = "New starter doc" })

-- Submenu 1: Programming Languages & Stacks (<leader>Fl...)
vim.keymap.set("n", "<leader>Fli", function()
  M.lang_init()
end, { desc = "Full setup (init)" })
vim.keymap.set("n", "<leader>Flp", function()
  M.lang_project()
end, { desc = "Project configs" })
vim.keymap.set("n", "<leader>Fln", function()
  M.lang_new()
end, { desc = "New starter file" })
vim.keymap.set("n", "<leader>Fls", function()
  M.lang_shell()
end, { desc = "Add flake and .envrc" })
vim.keymap.set("n", "<leader>Fll", function()
  M.list()
end, { desc = "List roles & stacks" })
vim.keymap.set("n", "<leader>Fla", function()
  M.active()
end, { desc = "List active roles" })

-- Submenu 2: Writing & Documents (<leader>Fw...)
vim.keymap.set("n", "<leader>Fwi", function()
  M.writing_init()
end, { desc = "Full setup (init)" })
vim.keymap.set("n", "<leader>Fwp", function()
  M.writing_project()
end, { desc = "Project configs" })
vim.keymap.set("n", "<leader>Fwn", function()
  M.writing_new()
end, { desc = "New starter doc" })
vim.keymap.set("n", "<leader>Fws", function()
  M.writing_shell()
end, { desc = "Add flake and .envrc" })
vim.keymap.set("n", "<leader>FwP", function()
  M.writing_packages()
end, { desc = "Configure packages" })

return M
