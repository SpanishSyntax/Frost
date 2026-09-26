-- lua/frost/tools/pdf_viewers.lua
local M = {}

--- Launch an external application with a target file path
---@param app string|table
---@param path string
---@param opts? { new_instance?: boolean }
function M.open(app, path, opts)
  opts = opts or {}

  if not path or path == "" then
    vim.notify("No file path provided", vim.log.levels.WARN)
    return
  end

  local full_path = vim.fn.fnamemodify(path, ":p")

  if vim.fn.filereadable(full_path) == 0 then
    vim.notify("File not found or unreadable: " .. full_path, vim.log.levels.WARN)
    return
  end

  local cmd = {}

  if app == "sioyek" then
    cmd = { "sioyek" }
    if opts.new_instance then
      table.insert(cmd, "--new-instance")
    end
    table.insert(cmd, full_path)
  elseif type(app) == "table" then
    cmd = vim.list_extend({}, app)
    table.insert(cmd, full_path)
  else
    cmd = { app, full_path }
  end

  local job_id = vim.fn.jobstart(cmd, {
    detach = true,
    on_stderr = function(_, data)
      local msg = table.concat(data, ""):gsub("^%s*(.-)%s*$", "%1")
      if msg ~= "" and not msg:match("Couldn't load pipewire") then
        vim.notify("Sioyek: " .. msg, vim.log.levels.WARN)
      end
    end,
  })

  if job_id <= 0 then
    vim.notify("Failed to start process: " .. vim.inspect(cmd), vim.log.levels.ERROR)
    return
  end

  local app_name = type(app) == "table" and app[1] or app
  local mode_label = (app == "sioyek" and opts.new_instance) and " (new window)" or ""
  vim.notify(
    "Opened with " .. app_name .. mode_label .. ": " .. vim.fn.fnamemodify(full_path, ":t"),
    vim.log.levels.INFO
  )
end

--- Resolve PDF path from current buffer and launch
---@param app string|table
---@param opts? { new_instance?: boolean }
function M.open_current_buffer(app, opts)
  local current_path = vim.api.nvim_buf_get_name(0)

  if current_path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local pdf_file = current_path
  if not current_path:match("%.pdf$") then
    pdf_file = vim.fn.expand("%:p:r") .. ".pdf"
  end

  M.open(app, pdf_file, opts)
end

-- Keymaps
vim.keymap.set("n", "<leader>wz", function()
  M.open_current_buffer("zathura")
end, { desc = "Open PDF in Zathura", silent = true })

-- Normal mode (isolated instance)
vim.keymap.set("n", "<leader>ws", function()
  M.open_current_buffer("sioyek", { new_instance = true })
end, { desc = "Open PDF in Sioyek (reuse)", silent = true })

-- New window mode (re-use instance)
vim.keymap.set("n", "<leader>wS", function()
  M.open_current_buffer("sioyek", { new_instance = false })
end, { desc = "Open PDF in Sioyek (new window)", silent = true })

vim.keymap.set("n", "<leader>wx", function()
  M.open_current_buffer("xdg-open")
end, { desc = "Open PDF in default app", silent = true })

return M
