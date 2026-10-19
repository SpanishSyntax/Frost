-- lua/frost/tools/flaker.lua
local common = require("frost.tools.common")
local M = {}

local function run_interactive(cmd, cwd, title, target_file)
  title = title and ("❄️ " .. title) or "❄️ Flaker"
  common.run_interactive(cmd, cwd, title, target_file)
end

-- ===================================================================
-- Core Dispatchers
-- ===================================================================

--- Workspace Initialization Dispatcher (<leader>wki)
function M.init()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Bootstrap Folio Workspace (Report)", cmd = { "flaker", "init", "folio", "report" }, file = "report.md" },
    { label = "󱓷 Bootstrap Folio Workspace (16:9 Slides)", cmd = { "flaker", "init", "folio", "slides" }, file = "slides.md" },
    { label = "󱓷 Bootstrap Folio Workspace (IEEE Paper)", cmd = { "flaker", "init", "folio", "paper" }, file = "paper.md" },
    { label = "󰬛 Bootstrap Native Typst Workspace (report.typ)", cmd = { "flaker", "init", "typ" }, file = "report.typ" },
    { label = " Bootstrap Native LaTeX Workspace (report.tex)", cmd = { "flaker", "init", "tex" }, file = "report.tex" },
    { label = "❄️ Interactive Polyglot Stack Bootstrap Wizard", cmd = { "flaker", "init" } },
  }

  vim.ui.select(items, {
    prompt = "❄️ Bootstrap Workspace (Flaker Init)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Template Foundations & Scaffolding Dispatcher (<leader>wks)
function M.scaffold()
  local doc = common.get_active_doc()
  local items = {
    { label = "󱓷 Drop Template Foundations (flaker project folio)", cmd = { "flaker", "project", "folio" } },
    { label = "󱓷 Scaffold All Templates & Foundations (flaker project folio -m all)", cmd = { "flaker", "project", "folio", "-m", "all" } },
    { label = "❄️ Generate DevShell Flake & Direnv (flaker shell)", cmd = { "flaker", "shell" } },
    { label = "󱓷 Generate Folio DevShell & Direnv (flaker shell folio)", cmd = { "flaker", "shell", "folio" } },
    { label = "󰒲 Interactive Project Scaffolder (flaker project)", cmd = { "flaker", "project" } },
  }

  vim.ui.select(items, {
    prompt = "❄️ Scaffolding & Foundations (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Dedicated Dispatcher for New Starter Documents (<leader>wkn)
--- (3 formats: md, typ, tex × 3 templates: report, slides, paper = 9 combinations)
function M.new()
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
    prompt = "❄️ New Starter Document",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Package Configuration Dispatcher (<leader>wkP)
function M.packages()
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
    prompt = "❄️ Configure Packages (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Interactive Stack Wizard & Role Selector (<leader>wkk / <leader>F)
function M.interactive()
  local doc = common.get_active_doc()
  run_interactive({ "flaker", "interactive" }, doc.dir, "Flaker Stack Selector")
end

--- List Registered Language Roles & Stacks (<leader>wkl)
function M.list()
  local doc = common.get_active_doc()
  run_interactive({ "flaker", "list" }, doc.dir, "Flaker Available Roles")
end

-- ===================================================================
-- Keymaps
-- ===================================================================

-- Primary Writing/Flaker sub-palette (<leader>wk...)
vim.keymap.set("n", "<leader>wki", function() M.init() end, { desc = "Flaker: Bootstrap workspace (init)" })
vim.keymap.set("n", "<leader>wks", function() M.scaffold() end, { desc = "Flaker: Scaffold foundations (project)" })
vim.keymap.set("n", "<leader>wkn", function() M.new() end, { desc = "Flaker: New starter document (md, typ, tex)" })
vim.keymap.set("n", "<leader>wkP", function() M.packages() end, { desc = "Flaker: Configure packages (packages)" })
vim.keymap.set("n", "<leader>wkk", function() M.interactive() end, { desc = "Flaker: Interactive stack selector" })
vim.keymap.set("n", "<leader>wkl", function() M.list() end, { desc = "Flaker: List registered stacks & roles" })

-- Root-level fast shortcuts (<leader>F...)
vim.keymap.set("n", "<leader>F", function() M.interactive() end, { desc = "Flaker: Interactive stack selector" })
vim.keymap.set("n", "<leader>Fi", function() M.init() end, { desc = "Flaker: Bootstrap workspace (init)" })
vim.keymap.set("n", "<leader>Fs", function() M.scaffold() end, { desc = "Flaker: Scaffold foundations (project)" })
vim.keymap.set("n", "<leader>Fn", function() M.new() end, { desc = "Flaker: New starter document" })
vim.keymap.set("n", "<leader>FP", function() M.packages() end, { desc = "Flaker: Configure packages" })

return M
