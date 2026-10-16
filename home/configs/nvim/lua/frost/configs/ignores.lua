-- lua/frost/configs/ignores.lua
local M = {}

M.default_ignore_directories = { ".git", ".direnv", ".venv", "node_modules" }
M.default_ignore_files = { ".DS_Store", "Thumbs.db" }

--- Returns formatted glob exclusions for file pickers and search engines
---@return string[]
function M.get_excludes()
  local excludes = {}
  local dirs = vim.g.frost_ignore_directories or M.default_ignore_directories
  for _, dir in ipairs(dirs) do
    table.insert(excludes, "**/" .. dir)
    table.insert(excludes, "**/" .. dir .. "/**")
  end

  local files = vim.g.frost_ignore_files or M.default_ignore_files
  for _, file in ipairs(files) do
    table.insert(excludes, "**/" .. file)
  end

  return excludes
end

return M
