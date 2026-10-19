-- lua/frost/tools/folio.lua
local common = require("frost.tools.common")
local M = {}

-- ===================================================================
-- Helpers
-- ===================================================================

--- Runs an external command in the target directory with notification output
local function run_cmd(cmd, cwd, title, on_success)
  common.run_cmd(cmd, cwd, title or "folio", on_success)
end

--- Finds the latest or matching PDF in active directory and opens it
local function open_output_pdf()
  local doc = common.get_active_doc()
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
        vim.notify(
          "Opening " .. vim.fn.fnamemodify(expected_pdf, ":t"),
          vim.log.levels.INFO,
          { title = "folio" }
        )
        return
      end
    end
  end

  -- 2. Fallback: search for all PDFs in folder and sort by mod time
  local pdfs = vim.fn.glob(target_dir .. "/*.pdf", false, true)
  if #pdfs == 0 then
    vim.notify(
      "No PDF found in " .. target_dir .. ". Build the document first!",
      vim.log.levels.WARN,
      { title = "folio" }
    )
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
    vim.notify(
      "Opening " .. vim.fn.fnamemodify(pdfs[1], ":t"),
      vim.log.levels.INFO,
      { title = "folio" }
    )
  end
end

-- ===================================================================
-- Core Actions
-- ===================================================================

--- Build document with Folio
---@param opts? { mode?: string, open?: boolean }
function M.build(opts)
  opts = opts or {}
  local doc = common.get_active_doc()
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
  local doc = common.get_active_doc()
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
  local doc = common.get_active_doc()
  if not doc.is_doc then
    vim.notify(
      "Active buffer is not a recognized document (.md, .typ, .tex)",
      vim.log.levels.WARN,
      { title = "folio" }
    )
    return
  end

  if doc.ext == "typ" or doc.ext == "tex" then
    vim.notify(
      "Native "
        .. doc.ext:upper()
        .. " documents define layout directly in markup. Compiling directly...",
      vim.log.levels.INFO,
      { title = "folio" }
    )
    M.build({ open = true })
    return
  end

  local modes = {
    {
      id = "report",
      label = "󱓷 Report (Clean A4/Letter Technical Report)",
      desc = "Uses report.typ / template.typ",
    },
    {
      id = "slides",
      label = "󱓷 Slides (16:9 Widescreen Presentation)",
      desc = "Uses slides.typ (1920x1080)",
    },
    {
      id = "paper",
      label = "󱓷 Paper (Academic IEEE 2-Column Paper)",
      desc = "Uses paper.typ / ieee.typ",
    },
  }

  vim.ui.select(modes, {
    prompt = "󱓷 Select Mode Override (" .. doc.filename .. ")",
    format_item = function(item)
      return item.label .. " — " .. item.desc
    end,
  }, function(choice)
    if choice then
      M.build({ mode = choice.id, open = true })
    end
  end)
end

-- ===================================================================
-- Keymaps
-- ===================================================================

-- Unified top-level writing shortcuts
vim.keymap.set("n", "<leader>wb", function()
  M.build()
end, { desc = "PDF: Build current document" })
vim.keymap.set("n", "<leader>ww", function()
  M.watch()
end, { desc = "PDF: Watch with live reload" })
vim.keymap.set("n", "<leader>wp", function()
  M.build({ open = true })
end, { desc = "PDF: Build and view PDF" })

-- Detailed Folio sub-palette (<leader>wf...)
vim.keymap.set("n", "<leader>wfb", function()
  M.build()
end, { desc = "Folio: Build current document" })
vim.keymap.set("n", "<leader>wfw", function()
  M.watch()
end, { desc = "Folio: Watch with live reload" })
vim.keymap.set("n", "<leader>wfp", function()
  M.build({ open = true })
end, { desc = "Folio: Build & open PDF" })
vim.keymap.set("n", "<leader>wfm", function()
  M.select_mode_and_build()
end, { desc = "Folio: Mode override & build..." })
vim.keymap.set("n", "<leader>wfv", open_output_pdf, { desc = "Folio: View output" })

return M
