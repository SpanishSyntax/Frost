-- lua/frost/tools/folio.lua

-- ===================================================================
-- Helpers
-- ===================================================================

-- Gets the directory of the currently open buffer file (or falls back to CWD)
local function get_active_dir()
  local file_dir = vim.fn.expand("%:p:h")
  if file_dir == "" then
    return vim.fn.getcwd()
  end
  return file_dir
end

-- 1. Runs folio in the active file's directory
local function run_folio(arg, on_success)
  local target_dir = get_active_dir()

  vim.notify(
    "Running folio " .. arg .. " in " .. target_dir,
    vim.log.levels.INFO,
    { title = "folio" }
  )

  local output = {}

  vim.fn.jobstart({ "folio", arg }, {
    cwd = target_dir,
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
      local msg = #output > 0 and table.concat(output, "\n") or ("folio " .. arg .. " finished")
      if exit_code == 0 then
        vim.notify(msg, vim.log.levels.INFO, { title = "folio" })
        if on_success then
          on_success()
        end
      else
        vim.notify("Failed:\n" .. msg, vim.log.levels.ERROR, { title = "folio" })
      end
    end,
  })
end

-- 2. Finds the latest PDF in the active file's directory and opens it
local function open_latest_pdf()
  local target_dir = get_active_dir()

  -- Search for PDFs specifically in the active file's folder
  local pdfs = vim.fn.glob(target_dir .. "/*.pdf", false, true)

  if #pdfs == 0 then
    vim.notify(
      "No PDF found in " .. target_dir .. ". Run build first!",
      vim.log.levels.WARN,
      { title = "folio" }
    )
    return
  end

  -- Sort by modification time (latest first)
  table.sort(pdfs, function(a, b)
    return vim.fn.getftime(a) > vim.fn.getftime(b)
  end)

  local opener = vim.fn.executable("zathura") == 1 and "zathura" or "xdg-open"
  vim.fn.jobstart({ opener, pdfs[1] }, { cwd = target_dir, detach = true })
  vim.notify("Opening " .. pdfs[1], vim.log.levels.INFO, { title = "folio" })
end

-- ===================================================================
-- Keymaps
-- ===================================================================

-- Scaffold files in active buffer's directory
vim.keymap.set("n", "<leader>wfi", function()
  run_folio("init")
end, { desc = "Folio: Scaffold files in current buffer dir" })

-- Build PDF in active buffer's directory
vim.keymap.set("n", "<leader>wfb", function()
  run_folio("build")
end, { desc = "Folio: Build PDF in current buffer dir" })

-- Open latest PDF in active buffer's directory
vim.keymap.set("n", "<leader>wfv", open_latest_pdf, { desc = "Folio: View output PDF" })

-- Build AND open on success
vim.keymap.set("n", "<leader>wfp", function()
  run_folio("build", open_latest_pdf)
end, { desc = "Folio: Build and view PDF" })
