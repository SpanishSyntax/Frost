-- lua/frost/tools/common.lua
local M = {}

--- Resolves active document path, directory, filename, extension, and document type
---@return { path: string, filename: string, dir: string, ext: string, is_doc: boolean }
function M.get_active_doc()
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

--- Runs an external batch command with notification output
---@param cmd string[] Command and arguments
---@param cwd? string Working directory (defaults to active doc directory or current working directory)
---@param title? string Notification title
---@param on_success? fun() Callback on exit code 0
function M.run_cmd(cmd, cwd, title, on_success)
  local doc = M.get_active_doc()
  cwd = (cwd and cwd ~= "") and cwd or ((doc.dir and doc.dir ~= "") and doc.dir or vim.fn.getcwd())
  title = title or "frost"

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
---@param cmd string[] Command and arguments
---@param cwd? string Working directory (defaults to active doc directory or current working directory)
---@param title? string Terminal window title
---@param target_file? string File to automatically open upon exit if created
function M.run_interactive(cmd, cwd, title, target_file)
  local doc = M.get_active_doc()
  cwd = (cwd and cwd ~= "") and cwd or ((doc.dir and doc.dir ~= "") and doc.dir or vim.fn.getcwd())
  title = title or "Terminal"

  local augroup_id = "FrostInteractiveTerminal_" .. tostring(math.random(100000, 999999))
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
            vim.notify("Opened " .. target_file, vim.log.levels.INFO, { title = title })
          end
        end
      end)
    end,
  })

  if _G.Snacks and _G.Snacks.terminal then
    _G.Snacks.terminal(cmd, {
      cwd = cwd,
      win = {
        title = " " .. title .. " ",
        title_pos = "center",
      },
    })
  else
    vim.cmd("botright split | resize 15 | terminal " .. table.concat(cmd, " "))
  end
end

return M
