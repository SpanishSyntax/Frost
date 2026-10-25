-- lua/frost/tools/goggles.lua
local common = require("frost.tools.common")

-- ===================================================================
-- Helpers
-- ===================================================================

local function get_active_markdown()
  local doc = common.get_active_doc()
  if doc.path ~= "" and (doc.ext == "md" or doc.ext == "markdown") then
    return doc.path, doc.dir
  end
  return doc.dir, doc.dir
end

local function launch_goggles(extra_args)
  local target, cwd = get_active_markdown()
  local cmd = { "goggles", target }
  if extra_args then
    for _, a in ipairs(extra_args) do
      table.insert(cmd, a)
    end
  end

  vim.notify(
    "Opening " .. vim.fn.fnamemodify(target, ":t") .. " in Goggles",
    vim.log.levels.INFO,
    { title = "goggles" }
  )

  vim.fn.jobstart(cmd, {
    cwd = cwd,
    detach = true,
  })
end

-- ===================================================================
-- Keymaps
-- ===================================================================

-- Preview active Markdown buffer in Goggles native GFM viewer
vim.keymap.set("n", "<leader>wmp", function()
  launch_goggles()
end, { desc = "Goggles: Preview active markdown" })

-- Preview active Markdown buffer in GitHub Dark mode
vim.keymap.set("n", "<leader>wmd", function()
  launch_goggles({ "--dark" })
end, { desc = "Goggles: Preview in dark mode" })

-- Preview active Markdown buffer in Wide Frameless mode
vim.keymap.set("n", "<leader>wmw", function()
  launch_goggles({ "--wide", "--frameless" })
end, { desc = "Goggles: Preview in wide frameless window" })
