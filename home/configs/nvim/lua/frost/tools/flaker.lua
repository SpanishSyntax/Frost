-- lua/frost/tools/flaker.lua
local common = require("frost.tools.common")
local M = {}

-- ===================================================================
-- Helpers
-- ===================================================================

local function run_interactive(cmd, cwd, title, target_file)
  title = title and ("❄️ " .. title) or "❄️ Flaker"
  common.run_interactive(cmd, cwd, title, target_file)
end

-- ===================================================================
-- 1. Writing & Documents Dispatchers (<leader>Fw... and <leader>wk...)
-- ===================================================================

--- Workspace Initialization for Writing (<leader>Fwi, <leader>wki)
function M.writing_init()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Bootstrap Folio Workspace (Report)", cmd = { "flaker", "init", "folio", "report" }, file = "report.md" },
    { label = "󱓷 Bootstrap Folio Workspace (16:9 Slides)", cmd = { "flaker", "init", "folio", "slides" }, file = "slides.md" },
    { label = "󱓷 Bootstrap Folio Workspace (IEEE Paper)", cmd = { "flaker", "init", "folio", "paper" }, file = "paper.md" },
    { label = "󰬛 Bootstrap Native Typst Workspace (report.typ)", cmd = { "flaker", "init", "typ" }, file = "report.typ" },
    { label = " Bootstrap Native LaTeX Workspace (report.tex)", cmd = { "flaker", "init", "tex" }, file = "report.tex" },
    { label = "❄️ Interactive Document Stack Bootstrap Wizard", cmd = { "flaker", "init", "folio" } },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Bootstrap Writing Workspace (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Template Foundations & Scaffolding for Writing (<leader>Fws, <leader>wks)
function M.writing_scaffold()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Drop Template Foundations (flaker project folio)", cmd = { "flaker", "project", "folio" } },
    { label = "󱓷 Scaffold All Templates & Foundations (flaker project folio -m all)", cmd = { "flaker", "project", "folio", "-m", "all" } },
    { label = "󱓷 Generate Folio DevShell & Direnv (flaker shell folio)", cmd = { "flaker", "shell", "folio" } },
    { label = "󰒲 Interactive Folio Scaffolder (flaker project folio)", cmd = { "flaker", "project", "folio" } },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Document Foundations & Scaffolding (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Dedicated Starter Documents Generator (<leader>Fwn, <leader>wkn)
--- (3 formats: md, typ, tex × 3 templates: report, slides, paper = 9 combinations)
function M.writing_new()
  local doc = common.get_active_doc()
  local items = {
    -- Markdown Starters (md)
    { label = " Markdown Report (report.md)", cmd = { "flaker", "new", "md:report" }, file = "report.md" },
    { label = " Markdown 16:9 Slides (slides.md)", cmd = { "flaker", "new", "md:slides" }, file = "slides.md" },
    { label = " Markdown IEEE Paper (paper.md)", cmd = { "flaker", "new", "md:paper" }, file = "paper.md" },

    -- Typst Starters (typ)
    { label = " Typst Technical Report (report.typ)", cmd = { "flaker", "new", "typ:report" }, file = "report.typ" },
    { label = " Typst 16:9 Slides (slides.typ)", cmd = { "flaker", "new", "typ:slides" }, file = "slides.typ" },
    { label = " Typst IEEE Paper (paper.typ)", cmd = { "flaker", "new", "typ:paper" }, file = "paper.typ" },

    -- LaTeX Starters (tex)
    { label = " LaTeX Technical Report (report.tex)", cmd = { "flaker", "new", "tex:report" }, file = "report.tex" },
    { label = " LaTeX Presentation Slides (slides.tex)", cmd = { "flaker", "new", "tex:slides" }, file = "slides.tex" },
    { label = " LaTeX IEEE Paper (paper.tex)", cmd = { "flaker", "new", "tex:paper" }, file = "paper.tex" },
  }

  vim.ui.select(items, {
    prompt = "󱓷 New Starter Document",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Package Configuration Dispatcher (<leader>FwP, <leader>wkP)
function M.writing_packages()
  local doc = common.get_active_doc()
  local is_tex = doc.ext == "tex"
  local is_typ = doc.ext == "typ"

  local items = {
    {
      label = (is_typ and "󰬛 " or " ") .. "Configure Typst Packages (packages.typ)" .. (is_typ and " (Active Buffer)" or ""),
      cmd = { "flaker", "packages", "typ" },
      file = "packages.typ",
    },
    {
      label = (is_tex and " " or " ") .. "Configure LaTeX Packages (packages.tex)" .. (is_tex and " (Active Buffer)" or ""),
      cmd = { "flaker", "packages", "tex" },
      file = "packages.tex",
    },
  }

  -- Prioritize active buffer's document format
  if is_tex then
    table.sort(items, function(a, b) return a.cmd[3] == "tex" end)
  elseif is_typ then
    table.sort(items, function(a, b) return a.cmd[3] == "typ" end)
  end

  vim.ui.select(items, {
    prompt = "󱓷 Configure Packages (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
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
    { label = " Python (Python 3.14 + uv + ruff + ty)", cmd = { "flaker", "init", "py" }, file = "pyproject.toml" },
    { label = "󰦨 MathVis Simulation (Python 3.14 + scientific stack)", cmd = { "flaker", "init", "mv" }, file = "plot.py" },
    { label = " Julia (Julia S&C + Formatter)", cmd = { "flaker", "init", "julia" }, file = "Project.toml" },

    -- Systems
    { label = " Rust (Cargo + rust-analyzer + lldb)", cmd = { "flaker", "init", "rust" }, file = "Cargo.toml" },
    { label = " Go (Go toolchain + gopls + delve)", cmd = { "flaker", "init", "go" }, file = "go.mod" },
    { label = " C++ / C (Clang/GCC + clangd + cmake + ninja)", cmd = { "flaker", "init", "cpp" }, file = "CMakeLists.txt" },
    { label = " Zig (Zig compiler + zls LSP)", cmd = { "flaker", "init", "zig" }, file = "build.zig" },
    { label = "󰌛 .NET / C# (.NET 9 SDK + Omnisharp)", cmd = { "flaker", "init", "dotnet" } },
    { label = " Java (OpenJDK 25 + jdtls + maven/gradle)", cmd = { "flaker", "init", "java" } },

    -- Web & Frontend
    { label = " TypeScript / JS (Bun + vtsls + prettierd)", cmd = { "flaker", "init", "ts" }, file = "package.json" },
    { label = "󰄛 Next.js (Next.js + Bun + vtsls)", cmd = { "flaker", "init", "next" }, file = "package.json" },
    { label = " Svelte (Svelte 5 + Bun + svelte-ls)", cmd = { "flaker", "init", "svelte" }, file = "package.json" },
    { label = "󰡄 Vue (Vue 3 + Bun + vue-ls)", cmd = { "flaker", "init", "vue" }, file = "package.json" },

    -- Functional
    { label = " Elixir (Elixir + Mix + elixir-ls)", cmd = { "flaker", "init", "elixir" }, file = "mix.exs" },
    { label = " Gleam (Gleam + Erlang runtime + rebar3)", cmd = { "flaker", "init", "gleam" }, file = "gleam.toml" },
    { label = " Haskell (GHC + Cabal + HLS + Ormolu)", cmd = { "flaker", "init", "haskell" } },

    -- DevOps & Cloud
    { label = "󰡨 DevOps (Docker Compose + Lazydocker + K8s)", cmd = { "flaker", "init", "ops" }, file = "compose.yaml" },

    -- Universal
    { label = "❄️ Custom Polyglot Bootstrap (Interactive Selector)", cmd = { "flaker", "init" } },
  }

  vim.ui.select(items, {
    prompt = " Bootstrap Language Workspace (Flaker Init)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Project Foundation Scaffolding (<leader>Fls)
function M.lang_scaffold()
  local doc = common.get_active_doc()
  local items = {
    { label = " Python Foundation (pyproject.toml)", cmd = { "flaker", "project", "py" }, file = "pyproject.toml" },
    { label = " Rust Foundation (Cargo.toml)", cmd = { "flaker", "project", "rust" }, file = "Cargo.toml" },
    { label = " Go Foundation (go.mod)", cmd = { "flaker", "project", "go" }, file = "go.mod" },
    { label = " TypeScript Foundation (package.json)", cmd = { "flaker", "project", "ts" }, file = "package.json" },
    { label = " C++ Foundation (CMakeLists.txt)", cmd = { "flaker", "project", "cpp" }, file = "CMakeLists.txt" },
    { label = " Zig Foundation (build.zig)", cmd = { "flaker", "project", "zig" }, file = "build.zig" },
    { label = " Julia Foundation (Project.toml)", cmd = { "flaker", "project", "julia" }, file = "Project.toml" },
    { label = " Elixir Foundation (mix.exs)", cmd = { "flaker", "project", "elixir" }, file = "mix.exs" },
    { label = " Gleam Foundation (gleam.toml)", cmd = { "flaker", "project", "gleam" }, file = "gleam.toml" },
    { label = "󰡨 DevOps Foundation (compose.yaml)", cmd = { "flaker", "project", "ops" }, file = "compose.yaml" },
    { label = "❄️ Interactive Foundation Scaffolder", cmd = { "flaker", "project" } },
  }

  vim.ui.select(items, {
    prompt = " Scaffold Project Foundations (Flaker Project)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Drop Language Starter Files (<leader>Fln)
function M.lang_new()
  local doc = common.get_active_doc()
  local items = {
    { label = " Python Starter (main.py)", cmd = { "flaker", "new", "py" }, file = "main.py" },
    { label = "󰦨 MathVis Plot Script (plot.py)", cmd = { "flaker", "new", "mv" }, file = "plot.py" },
    { label = " Rust Starter (src/main.rs)", cmd = { "flaker", "new", "rust" }, file = "src/main.rs" },
    { label = " Go Starter (main.go)", cmd = { "flaker", "new", "go" }, file = "main.go" },
    { label = " TypeScript Starter (index.ts)", cmd = { "flaker", "new", "ts" }, file = "index.ts" },
    { label = " C++ Starter (main.cpp)", cmd = { "flaker", "new", "cpp" }, file = "main.cpp" },
    { label = " Zig Starter (src/main.zig)", cmd = { "flaker", "new", "zig" }, file = "src/main.zig" },
    { label = " Julia Starter (main.jl)", cmd = { "flaker", "new", "julia" }, file = "main.jl" },
    { label = " Elixir Starter (lib/main.ex)", cmd = { "flaker", "new", "elixir" }, file = "lib/main.ex" },
    { label = " Gleam Starter (src/main.gleam)", cmd = { "flaker", "new", "gleam" }, file = "src/main.gleam" },
    { label = " Haskell Starter (app/Main.hs)", cmd = { "flaker", "new", "haskell" }, file = "app/Main.hs" },
    { label = "❄️ Interactive Starter Drop (flaker new)", cmd = { "flaker", "new" } },
  }

  vim.ui.select(items, {
    prompt = " Drop Starter File (Flaker New)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Generate Language DevShell Only (<leader>FlS)
function M.lang_shell()
  local doc = common.get_active_doc()
  local items = {
    { label = " Python DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "py" }, file = "flake.nix" },
    { label = " Rust DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "rust" }, file = "flake.nix" },
    { label = " Go DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "go" }, file = "flake.nix" },
    { label = " TypeScript / Bun DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "ts" }, file = "flake.nix" },
    { label = " C++ DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "cpp" }, file = "flake.nix" },
    { label = " Zig DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "zig" }, file = "flake.nix" },
    { label = " Julia DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "julia" }, file = "flake.nix" },
    { label = "󰡨 DevOps DevShell (flake.nix + .envrc)", cmd = { "flaker", "shell", "ops" }, file = "flake.nix" },
    { label = "❄️ Interactive DevShell Generator", cmd = { "flaker", "shell" }, file = "flake.nix" },
  }

  vim.ui.select(items, {
    prompt = " Generate DevShell (Flaker Shell)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
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

--- List Registered Language Roles & Stacks (<leader>Fll, <leader>wkl)
function M.list()
  local doc = common.get_active_doc()
  run_interactive({ "flaker", "list" }, doc.dir, "Flaker Available Roles")
end

-- Backward compatibility aliases
M.init = M.writing_init
M.scaffold = M.writing_scaffold
M.new = M.writing_new
M.packages = M.writing_packages

-- ===================================================================
-- Keymaps
-- ===================================================================

-- -------------------------------------------------------------------
-- A. Flaker Top-Level Palette (<leader>F...)
-- -------------------------------------------------------------------

-- Interactive Wizard & Root Shortcuts
vim.keymap.set("n", "<leader>Fk", function() M.interactive() end, { desc = "Flaker: Interactive stack selector" })
vim.keymap.set("n", "<leader>Fp", function() M.lang_scaffold() end, { desc = "Flaker: Scaffold project foundations (project)" })
vim.keymap.set("n", "<leader>Fs", function() M.lang_shell() end, { desc = "Flaker: Generate DevShell flake (shell)" })
vim.keymap.set("n", "<leader>Fn", function() M.writing_new() end, { desc = "Flaker: New starter document/file (new)" })
vim.keymap.set("n", "<leader>FP", function() M.writing_packages() end, { desc = "Flaker: Configure packages" })

-- Submenu 1: Programming Languages & Stacks (<leader>Fl...)
vim.keymap.set("n", "<leader>Fli", function() M.lang_init() end, { desc = "Langs: Bootstrap language workspace (init)" })
vim.keymap.set("n", "<leader>Flp", function() M.lang_scaffold() end, { desc = "Langs: Scaffold project foundations (project)" })
vim.keymap.set("n", "<leader>Fls", function() M.lang_scaffold() end, { desc = "Langs: Scaffold project foundations (scaffold)" })
vim.keymap.set("n", "<leader>Fln", function() M.lang_new() end, { desc = "Langs: Drop starter code file (new)" })
vim.keymap.set("n", "<leader>FlS", function() M.lang_shell() end, { desc = "Langs: Generate DevShell only (shell)" })
vim.keymap.set("n", "<leader>Fll", function() M.list() end, { desc = "Langs: List registered roles & stacks" })

-- Submenu 2: Writing & Documents (<leader>Fw...)
vim.keymap.set("n", "<leader>Fwi", function() M.writing_init() end, { desc = "Writing: Bootstrap document workspace (init)" })
vim.keymap.set("n", "<leader>Fwp", function() M.writing_scaffold() end, { desc = "Writing: Scaffold document foundations (project)" })
vim.keymap.set("n", "<leader>Fws", function() M.writing_scaffold() end, { desc = "Writing: Scaffold document foundations (scaffold)" })
vim.keymap.set("n", "<leader>Fwn", function() M.writing_new() end, { desc = "Writing: New starter document (new)" })
vim.keymap.set("n", "<leader>FwP", function() M.writing_packages() end, { desc = "Writing: Configure package bundles" })

-- -------------------------------------------------------------------
-- B. Writing Palette Convenience Shortcuts (<leader>wk...)
-- -------------------------------------------------------------------
vim.keymap.set("n", "<leader>wki", function() M.writing_init() end, { desc = "Flaker: Bootstrap workspace (init)" })
vim.keymap.set("n", "<leader>wkp", function() M.writing_scaffold() end, { desc = "Flaker: Scaffold foundations (project)" })
vim.keymap.set("n", "<leader>wks", function() M.writing_scaffold() end, { desc = "Flaker: Scaffold foundations (scaffold)" })
vim.keymap.set("n", "<leader>wkn", function() M.writing_new() end, { desc = "Flaker: New starter document (md, typ, tex)" })
vim.keymap.set("n", "<leader>wkP", function() M.writing_packages() end, { desc = "Flaker: Configure packages (packages)" })
vim.keymap.set("n", "<leader>wkk", function() M.interactive() end, { desc = "Flaker: Interactive stack selector" })
vim.keymap.set("n", "<leader>wkl", function() M.list() end, { desc = "Flaker: List registered stacks & roles" })

return M
