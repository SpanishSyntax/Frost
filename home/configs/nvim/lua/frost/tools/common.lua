-- lua/frost/tools/common.lua
local M = {}

--- Resolves the most appropriate context directory based on current focus:
--- 1. If currently focused in Snacks Explorer -> highlighted item's directory or explorer cwd
--- 2. If Oil buffer -> oil directory
--- 3. If Netrw buffer -> netrw directory
--- 4. If normal file buffer -> file's parent directory
--- 5. If dashboard/scratch/empty and Snacks Explorer is open in tabpage -> explorer's highlighted directory
--- 6. Fallback -> vim.fn.getcwd()
---@return { dir: string, rel_dir: string }
function M.get_context_dir()
  local cwd = vim.fs.normalize(vim.fn.getcwd())
  local dir = nil

  -- 1. Check if focused window is Snacks explorer
  if _G.Snacks and _G.Snacks.picker and _G.Snacks.picker.get then
    local pickers = _G.Snacks.picker.get()
    for _, picker in ipairs(pickers) do
      if picker:current_win() and picker.opts and picker.opts.source == "explorer" then
        dir = picker:dir()
        break
      end
    end
  end

  -- 2. Check filetypes / special buffers
  if not dir or dir == "" then
    local bt = vim.bo.buftype
    local ft = vim.bo.filetype

    if ft == "oil" then
      local ok, oil = pcall(require, "oil")
      if ok and oil.get_current_dir then
        dir = oil.get_current_dir()
      end
    elseif ft == "netrw" and vim.b.netrw_curdir and vim.b.netrw_curdir ~= "" then
      dir = vim.b.netrw_curdir
    elseif bt == "" then
      local buf_name = vim.api.nvim_buf_get_name(0)
      if buf_name ~= "" then
        if vim.fn.isdirectory(buf_name) == 1 then
          dir = buf_name
        else
          dir = vim.fs.dirname(buf_name)
        end
      end
    end
  end

  -- 3. Check open Snacks explorer in current tab
  if not dir or dir == "" then
    if _G.Snacks and _G.Snacks.picker and _G.Snacks.picker.get then
      local explorers = _G.Snacks.picker.get({ source = "explorer" })
      if explorers and #explorers > 0 and not explorers[1].closed then
        dir = explorers[1]:dir()
      end
    end
  end

  -- 4. Fallback to process cwd
  if not dir or dir == "" then
    dir = cwd
  end

  dir = vim.fs.normalize(dir)
  local rel_dir
  if dir == cwd then
    rel_dir = "./"
  elseif vim.startswith(dir, cwd .. "/") then
    rel_dir = "./" .. dir:sub(#cwd + 2) .. "/"
  else
    rel_dir = dir .. "/"
  end

  return {
    dir = dir,
    rel_dir = rel_dir,
  }
end

--- Resolves active document path, directory, filename, extension, and document type
---@return { path: string, filename: string, dir: string, ext: string, is_doc: boolean }
function M.get_active_doc()
  local file_path = vim.api.nvim_buf_get_name(0)
  local ctx = M.get_context_dir()
  local file_dir = ctx.dir

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
---@param cwd? string Working directory (defaults to context directory or current working directory)
---@param title? string Notification title
---@param on_success? fun() Callback on exit code 0
function M.run_cmd(cmd, cwd, title, on_success)
  local ctx = M.get_context_dir()
  cwd = (cwd and cwd ~= "") and cwd or ctx.dir
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
---@param cwd? string Working directory (defaults to context directory or current working directory)
---@param title? string Terminal window title
---@param target_file? string File to automatically open upon exit if created
---@param opts? { interactive?: boolean, auto_close?: boolean, win?: table } Additional terminal options
function M.run_interactive(cmd, cwd, title, target_file, opts)
  local ctx = M.get_context_dir()
  cwd = (cwd and cwd ~= "") and cwd or ctx.dir
  title = title or "Terminal"
  opts = opts or {}

  local interactive = opts.interactive ~= false
  local auto_close = opts.auto_close
  if auto_close == nil then
    auto_close = interactive
  end

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

            -- Refresh Snacks Explorer if open and reveal new file
            if _G.Snacks and _G.Snacks.picker and _G.Snacks.picker.get then
              local explorers = _G.Snacks.picker.get({ source = "explorer" })
              if explorers and #explorers > 0 and not explorers[1].closed then
                local exp = explorers[1]
                local ok_a, Actions = pcall(require, "snacks.explorer.actions")
                if ok_a and Actions.update then
                  Actions.update(exp, { target = full_path, refresh = true })
                end
              end
            end
          end
        end
      end)
    end,
  })

  if _G.Snacks and _G.Snacks.terminal then
    local term_opts = {
      cwd = cwd,
      interactive = interactive,
      auto_close = auto_close,
      win = {
        title = " " .. title .. " ",
        title_pos = "center",
      },
    }
    if opts.win then
      term_opts.win = vim.tbl_deep_extend("force", term_opts.win, opts.win)
    end
    _G.Snacks.terminal(cmd, term_opts)
  else
    vim.cmd("botright split | resize 15 | terminal " .. table.concat(cmd, " "))
  end
end

return M
