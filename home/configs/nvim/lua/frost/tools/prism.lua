-- lua/frost/tools/prism.lua
local common = require("frost.tools.common")
local M = {}

-- Active server job tracker
M.active_server_job = nil

-- ===================================================================
-- Helpers
-- ===================================================================

--- Resolves the target plotting script or directory
local function get_target()
  local doc = common.get_active_doc()
  if doc.path ~= "" and doc.ext == "py" then
    return doc.path, doc.dir
  end
  local context = common.get_context_dir()
  return context.dir, context.dir
end

-- ===================================================================
-- Actions
-- ===================================================================

--- Launches live-reloading preview server in interactive terminal or background
function M.serve()
  local target, cwd = get_target()
  local target_name = vim.fn.fnamemodify(target, ":t")
  local cmd = { "prism", "serve", target }

  if _G.Snacks and _G.Snacks.terminal then
    _G.Snacks.terminal(cmd, {
      cwd = cwd,
      win = {
        title = " 💎 Prism Live-Reload Server (" .. target_name .. ") ",
        title_pos = "center",
      },
    })
  else
    vim.notify(
      "Starting Prism preview server for " .. target_name .. "...",
      vim.log.levels.INFO,
      { title = "prism" }
    )
    M.active_server_job = vim.fn.jobstart(cmd, {
      cwd = cwd,
      detach = true,
      on_exit = function(_, code)
        if code ~= 0 then
          vim.notify("Prism server exited with code " .. code, vim.log.levels.WARN, { title = "prism" })
        end
      end,
    })
  end
end

--- Batch builds plots in current directory into target format
---@param format string|nil Target format (html, svg, png, pdf)
function M.build(format)
  local _, cwd = get_target()
  local fmt = format or "html"
  local cmd = { "prism", "build", "-d", cwd, "-f", fmt, "--no-color" }

  vim.notify("Building plots (" .. fmt .. ")...", vim.log.levels.INFO, { title = "prism" })
  common.run_cmd(cmd, cwd, "prism build", function()
    vim.notify("Prism build complete (" .. fmt .. ")", vim.log.levels.INFO, { title = "prism" })
  end)
end

--- Lists discovered plotting scripts in current directory
function M.list()
  local _, cwd = get_target()
  local cmd = { "prism", "list", "-d", cwd, "--no-color" }

  common.run_cmd(cmd, cwd, "prism list", function(stdout)
    vim.notify(stdout or "No plot scripts detected.", vim.log.levels.INFO, { title = "prism" })
  end)
end

-- ===================================================================
-- Keymaps (<leader>p...)
-- ===================================================================

vim.keymap.set("n", "<leader>ps", function()
  M.serve()
end, { desc = "Prism: Serve active plot (live reload)" })

vim.keymap.set("n", "<leader>pb", function()
  M.build("html")
end, { desc = "Prism: Batch build plots (HTML)" })

vim.keymap.set("n", "<leader>pv", function()
  M.build("svg")
end, { desc = "Prism: Batch build vector plots (SVG)" })

vim.keymap.set("n", "<leader>pp", function()
  M.build("pdf")
end, { desc = "Prism: Batch build publication plots (PDF)" })

vim.keymap.set("n", "<leader>pr", function()
  M.build("png")
end, { desc = "Prism: Batch build raster plots (PNG)" })

vim.keymap.set("n", "<leader>pl", function()
  M.list()
end, { desc = "Prism: List plotting scripts" })

return M
