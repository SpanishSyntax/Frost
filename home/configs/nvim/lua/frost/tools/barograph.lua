-- lua/frost/tools/barograph.lua
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
  local cmd = { "barograph", "serve", target }

  if _G.Snacks and _G.Snacks.terminal then
    _G.Snacks.terminal(cmd, {
      cwd = cwd,
      win = {
        title = " 💎 Barograph Live-Reload Server (" .. target_name .. ") ",
        title_pos = "center",
      },
    })
  else
    vim.notify(
      "Starting Barograph preview server for " .. target_name .. "...",
      vim.log.levels.INFO,
      { title = "barograph" }
    )
    M.active_server_job = vim.fn.jobstart(cmd, {
      cwd = cwd,
      detach = true,
      on_exit = function(_, code)
        if code ~= 0 then
          vim.notify("Barograph server exited with code " .. code, vim.log.levels.WARN, { title = "barograph" })
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
  local cmd = { "barograph", "build", "-d", cwd, "-f", fmt, "--no-color" }

  vim.notify("Building plots (" .. fmt .. ")...", vim.log.levels.INFO, { title = "barograph" })
  common.run_cmd(cmd, cwd, "barograph build", function()
    vim.notify("Barograph build complete (" .. fmt .. ")", vim.log.levels.INFO, { title = "barograph" })
  end)
end

--- Lists discovered plotting scripts in current directory
function M.list()
  local _, cwd = get_target()
  local cmd = { "barograph", "list", "-d", cwd, "--no-color" }

  common.run_cmd(cmd, cwd, "barograph list", function(stdout)
    vim.notify(stdout or "No plot scripts detected.", vim.log.levels.INFO, { title = "barograph" })
  end)
end

-- ===================================================================
-- Keymaps (<leader>b...)
-- ===================================================================

vim.keymap.set("n", "<leader>bs", function()
  M.serve()
end, { desc = "Barograph: Serve active plot (live reload)" })

vim.keymap.set("n", "<leader>bb", function()
  M.build("html")
end, { desc = "Barograph: Batch build plots (HTML)" })

vim.keymap.set("n", "<leader>bv", function()
  M.build("svg")
end, { desc = "Barograph: Batch build vector plots (SVG)" })

vim.keymap.set("n", "<leader>bp", function()
  M.build("pdf")
end, { desc = "Barograph: Batch build publication plots (PDF)" })

vim.keymap.set("n", "<leader>br", function()
  M.build("png")
end, { desc = "Barograph: Batch build raster plots (PNG)" })

vim.keymap.set("n", "<leader>bl", function()
  M.list()
end, { desc = "Barograph: List plotting scripts" })

return M
