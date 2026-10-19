-- lua/frost/tools/folio.lua
local M = {}

-- ===================================================================
-- Helpers
-- ===================================================================

--- Resolves active document path, directory, and document type
local function get_active_doc()
  local file_path = vim.api.nvim_buf_get_name(0)
  local file_dir = vim.fn.expand("%:p:h")
  if file_dir == "" then
    file_dir = vim.fn.getcwd()
  end

  local filename = vim.fn.expand("%:t")
  local ext = vim.fn.expand("%:e"):lower()
  local is_doc = ext == "md" or ext == "markdown" or ext == "typ" or ext == "tex"

  return {
    path = file_path,
    filename = filename,
    dir = file_dir,
    ext = ext,
    is_doc = is_doc,
  }
end

--- Runs an external command in the target directory with notification output
local function run_cmd(cmd, cwd, title, on_success)
  cwd = cwd or vim.fn.getcwd()
  title = title or "folio"

  vim.notify(
    "Running: " .. table.concat(cmd, " ") .. " in " .. cwd,
    vim.log.levels.INFO,
    { title = title }
  )

  local output = {}

  vim.fn.jobstart(cmd, {
    cwd = cwd,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(output, line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            table.insert(output, line)
          end
        end
      end
    end,
    on_exit = function(_, exit_code, _)
      local msg = #output > 0 and table.concat(output, "\n") or (table.concat(cmd, " ") .. " finished")
      if exit_code == 0 then
        vim.notify(msg, vim.log.levels.INFO, { title = title })
        if on_success then
          on_success()
        end
      else
        vim.notify("Failed:\n" .. msg, vim.log.levels.ERROR, { title = title })
      end
    end,
  })
end

--- Runs an interactive command in a real terminal (Snacks float or split) with auto-reload
local function run_interactive(cmd, cwd, title, target_file)
  local doc = get_active_doc()
  cwd = (cwd and cwd ~= "") and cwd or ((doc.dir and doc.dir ~= "") and doc.dir or vim.fn.getcwd())
  title = title or "Flaker"

  local augroup_id = "FrostFlakerTerminal_" .. tostring(math.random(100000, 999999))
  local group = vim.api.nvim_create_augroup(augroup_id, { clear = true })

  vim.api.nvim_create_autocmd("TermClose", {
    group = group,
    once = true,
    callback = function()
      vim.schedule(function()
        vim.cmd("checktime")
        if target_file then
          local full_path = cwd .. "/" .. target_file
          if vim.fn.filereadable(full_path) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(full_path))
            vim.notify("Opened " .. target_file, vim.log.levels.INFO, { title = "folio" })
          end
        end
      end)
    end,
  })

  if _G.Snacks and _G.Snacks.terminal then
    _G.Snacks.terminal(cmd, {
      cwd = cwd,
      win = {
        title = " 󱓷 " .. title .. " ",
        title_pos = "center",
      },
    })
  else
    vim.cmd("botright split | resize 15 | terminal " .. table.concat(cmd, " "))
  end
end

--- Finds the latest or matching PDF in active directory and opens it
local function open_output_pdf()
  local doc = get_active_doc()
  local target_dir = doc.dir

  -- 1. Try directly matching expected PDF name from current buffer
  if doc.is_doc and doc.path ~= "" then
    local expected_pdf = vim.fn.expand("%:p:r") .. ".pdf"
    if vim.fn.filereadable(expected_pdf) == 1 then
      local ok, pdf_viewers = pcall(require, "frost.tools.pdf_viewers")
      if ok and pdf_viewers.open then
        pdf_viewers.open("sioyek", expected_pdf, { new_instance = true })
        return
      else
        local opener = vim.fn.executable("zathura") == 1 and "zathura" or "xdg-open"
        vim.fn.jobstart({ opener, expected_pdf }, { cwd = target_dir, detach = true })
        vim.notify("Opening " .. vim.fn.fnamemodify(expected_pdf, ":t"), vim.log.levels.INFO, { title = "folio" })
        return
      end
    end
  end

  -- 2. Fallback: search for all PDFs in folder and sort by mod time
  local pdfs = vim.fn.glob(target_dir .. "/*.pdf", false, true)
  if #pdfs == 0 then
    vim.notify("No PDF found in " .. target_dir .. ". Build the document first!", vim.log.levels.WARN, { title = "folio" })
    return
  end

  table.sort(pdfs, function(a, b)
    return vim.fn.getftime(a) > vim.fn.getftime(b)
  end)

  local ok, pdf_viewers = pcall(require, "frost.tools.pdf_viewers")
  if ok and pdf_viewers.open then
    pdf_viewers.open("sioyek", pdfs[1], { new_instance = true })
  else
    local opener = vim.fn.executable("zathura") == 1 and "zathura" or "xdg-open"
    vim.fn.jobstart({ opener, pdfs[1] }, { cwd = target_dir, detach = true })
    vim.notify("Opening " .. vim.fn.fnamemodify(pdfs[1], ":t"), vim.log.levels.INFO, { title = "folio" })
  end
end

-- ===================================================================
-- Core Actions
-- ===================================================================

--- Build document with Folio
---@param opts? { mode?: string, open?: boolean }
function M.build(opts)
  opts = opts or {}
  local doc = get_active_doc()
  local cmd = { "folio" }

  if doc.is_doc and doc.filename ~= "" then
    table.insert(cmd, doc.filename)
  end

  if opts.mode then
    table.insert(cmd, "-m")
    table.insert(cmd, opts.mode)
  end

  if opts.open then
    table.insert(cmd, "--open")
  end

  run_cmd(cmd, doc.dir, "folio", function()
    if not opts.open then
      -- Notification only
    end
  end)
end

--- Watch document with Folio (live reloads on save)
function M.watch()
  local doc = get_active_doc()
  local target = (doc.is_doc and doc.filename ~= "") and doc.filename or ""

  local watch_cmd = { "folio" }
  if target ~= "" then
    table.insert(watch_cmd, target)
  end
  table.insert(watch_cmd, "-w")

  -- Use Snacks floating terminal if present, fallback to nvim terminal split
  if _G.Snacks and _G.Snacks.terminal then
    _G.Snacks.terminal(watch_cmd, {
      cwd = doc.dir,
      win = {
        title = " 󱓷 Folio Watch: " .. (target ~= "" and target or "workspace") .. " ",
        title_pos = "center",
      },
    })
  else
    vim.cmd("botright split | resize 12 | terminal " .. table.concat(watch_cmd, " "))
  end
end

--- Mode picker for Folio (Report, 16:9 Slides, Academic Paper)
--- Utility Note: Folio auto-detects `mode: ...` from Markdown YAML frontmatter and
--- compiles native .typ and .tex directly. This picker serves as an explicit mode
--- override when compiling Markdown notes/documents into different targets.
function M.select_mode_and_build()
  local doc = get_active_doc()
  if not doc.is_doc then
    vim.notify("Active buffer is not a recognized document (.md, .typ, .tex)", vim.log.levels.WARN, { title = "folio" })
    return
  end

  if doc.ext == "typ" or doc.ext == "tex" then
    vim.notify("Native " .. doc.ext:upper() .. " documents define layout directly in markup. Compiling directly...", vim.log.levels.INFO, { title = "folio" })
    M.build({ open = true })
    return
  end

  local modes = {
    { id = "report", label = "󱓷 Report (Clean A4/Letter Technical Report)", desc = "Uses report.typ / template.typ" },
    { id = "slides", label = "󱓷 Slides (16:9 Widescreen Presentation)", desc = "Uses slides.typ (1920x1080)" },
    { id = "paper",  label = "󱓷 Paper (Academic IEEE 2-Column Paper)", desc = "Uses paper.typ / ieee.typ" },
  }

  vim.ui.select(modes, {
    prompt = "󱓷 Select Mode Override (" .. doc.filename .. ")",
    format_item = function(item) return item.label .. " — " .. item.desc end,
  }, function(choice)
    if choice then
      M.build({ mode = choice.id, open = true })
    end
  end)
end

--- Flaker Workspace Initialization Dispatcher (<leader>wfi)
function M.flaker_init()
  local doc = get_active_doc()
  local items = {
    { label = "󱓷 Bootstrap Folio Workspace (Report)", cmd = { "flaker", "init", "folio", "report" }, file = "report.md" },
    { label = "󱓷 Bootstrap Folio Workspace (16:9 Slides)", cmd = { "flaker", "init", "folio", "slides" }, file = "slides.md" },
    { label = "󱓷 Bootstrap Folio Workspace (IEEE Paper)", cmd = { "flaker", "init", "folio", "paper" }, file = "paper.md" },
    { label = "󰬛 Bootstrap Native Typst Workspace (report.typ)", cmd = { "flaker", "init", "typ" }, file = "report.typ" },
    { label = " Bootstrap Native LaTeX Workspace (report.tex)", cmd = { "flaker", "init", "tex" }, file = "report.tex" },
    { label = "󰒲 Interactive Stack Bootstrap Wizard (flaker init)", cmd = { "flaker", "init" } },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Bootstrap Workspace (Flaker Init)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Flaker Template Foundations & Scaffolding Dispatcher (<leader>wfs)
function M.flaker_scaffold()
  local doc = get_active_doc()
  local items = {
    { label = "󱓷 Drop Template Foundations (flaker project folio)", cmd = { "flaker", "project", "folio" } },
    { label = "󱓷 Scaffold All Templates & Foundations (flaker project folio -m all)", cmd = { "flaker", "project", "folio", "-m", "all" } },
    { label = "󱓷 Generate DevShell & Direnv (flaker shell folio)", cmd = { "flaker", "shell", "folio" } },
    { label = "󰒲 Interactive Project Scaffolder (flaker project)", cmd = { "flaker", "project" } },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Scaffolding & Foundations (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end
    run_interactive(choice.cmd, doc.dir, choice.label, choice.file)
  end)
end

--- Dedicated Dispatcher for New Starter Documents (<leader>wfn)
--- (3 formats: md, typ, tex × 3 templates: report, slides, paper = 9 combinations)
function M.flaker_new()
  local doc = get_active_doc()
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

--- Flaker Package Configuration Dispatcher (<leader>wfP)
function M.flaker_packages()
  local doc = get_active_doc()
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
-- Keymaps
-- ===================================================================

-- Unified top-level writing shortcuts
vim.keymap.set("n", "<leader>wb", function() M.build() end, { desc = "PDF: Build current document" })
vim.keymap.set("n", "<leader>ww", function() M.watch() end, { desc = "PDF: Watch with live reload" })
vim.keymap.set("n", "<leader>wp", function() M.build({ open = true }) end, { desc = "PDF: Build and view PDF" })

-- Detailed Folio / Flaker sub-palette (<leader>wf...)
vim.keymap.set("n", "<leader>wfb", function() M.build() end, { desc = "Folio: Build current document" })
vim.keymap.set("n", "<leader>wfw", function() M.watch() end, { desc = "Folio: Watch with live reload" })
vim.keymap.set("n", "<leader>wfp", function() M.build({ open = true }) end, { desc = "Folio: Build & open PDF" })
vim.keymap.set("n", "<leader>wfm", function() M.select_mode_and_build() end, { desc = "Folio: Mode override & build..." })
vim.keymap.set("n", "<leader>wfv", open_output_pdf, { desc = "Folio: View output" })
vim.keymap.set("n", "<leader>wfi", function() M.flaker_init() end, { desc = "Flaker: Bootstrap workspace (init)" })
vim.keymap.set("n", "<leader>wfs", function() M.flaker_scaffold() end, { desc = "Flaker: Scaffold foundations (project)" })
vim.keymap.set("n", "<leader>wfn", function() M.flaker_new() end, { desc = "Flaker: New starter document (md, typ, tex)" })
vim.keymap.set("n", "<leader>wfP", function() M.flaker_packages() end, { desc = "Flaker: Configure packages (packages)" })

return M
