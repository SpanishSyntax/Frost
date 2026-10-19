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
function M.select_mode_and_build()
  local modes = {
    { id = "report", label = "Report (Minimal clean A4/Letter document)" },
    { id = "slides", label = "Slides (16:9 widescreen presentation)" },
    { id = "paper",  label = "Paper (Academic IEEE 2-column paper)" },
  }

  vim.ui.select(modes, {
    prompt = "󱓷 Select Operating Mode",
    format_item = function(item) return item.label end,
  }, function(choice)
    if choice then
      M.build({ mode = choice.id, open = true })
    end
  end)
end

--- Flaker Workspace & Document Scaffolding Dispatcher
function M.flaker_scaffold()
  local doc = get_active_doc()
  local items = {
    { label = "Bootstrap Folio Workspace (Report)", cmd = { "flaker", "init", "folio", "report" } },
    { label = "Bootstrap Folio Workspace (16:9 Slides)", cmd = { "flaker", "init", "folio", "slides" } },
    { label = "Bootstrap Folio Workspace (IEEE Paper)", cmd = { "flaker", "init", "folio", "paper" } },
    { label = "Drop Template Foundations (flaker project folio)", cmd = { "flaker", "project", "folio" } },
    { label = "New Starter Documents (flaker new folio)", cmd = { "flaker", "new", "folio" } },
    { label = "New Markdown Slides (slides.md)", cmd = { "flaker", "new", "md:slides" } },
    { label = "New Typst IEEE Paper (paper.typ)", cmd = { "flaker", "new", "typ:paper" } },
    { label = "New LaTeX Presentation Slides (slides.tex)", cmd = { "flaker", "new", "tex:slides" } },
    { label = "Configure Typst Packages (flaker packages typ)", cmd = { "flaker", "packages", "typ" } },
    { label = "Configure LaTeX Packages (flaker packages tex)", cmd = { "flaker", "packages", "tex" } },
  }

  vim.ui.select(items, {
    prompt = "󱓷 Scaffolding & Setup (Flaker)",
    format_item = function(item) return item.label end,
  }, function(choice)
    if not choice then return end

    -- Packages interactive commands need a real terminal
    if choice.cmd[2] == "packages" or choice.cmd[3] == "slides" then
      if _G.Snacks and _G.Snacks.terminal then
        _G.Snacks.terminal(choice.cmd, { cwd = doc.dir })
      else
        vim.cmd("botright split | resize 15 | terminal " .. table.concat(choice.cmd, " "))
      end
    else
      run_cmd(choice.cmd, doc.dir, "flaker", function()
        vim.cmd("checktime")
      end)
    end
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
vim.keymap.set("n", "<leader>wfm", function() M.select_mode_and_build() end, { desc = "Folio: Build with mode preset..." })
vim.keymap.set("n", "<leader>wfv", open_output_pdf, { desc = "Folio: View output" })
vim.keymap.set("n", "<leader>wfi", function() M.flaker_scaffold() end, { desc = "Folio: Scaffold workspace / documents" })

return M
