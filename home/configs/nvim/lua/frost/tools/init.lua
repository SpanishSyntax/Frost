-- lua/frost/tools/init.lua

-- 1. Get the absolute path to the directory containing THIS specific file (Nix-safe)
local current_file = debug.getinfo(1, "S").source:sub(2)
local tools_dir = vim.fn.fnamemodify(current_file, ":h")

-- 2. Open a filesystem scanner for that directory
local handle, err = vim.loop.fs_scandir(tools_dir)

if not handle then
  vim.notify("Could not read tools directory: " .. (err or ""), vim.log.levels.ERROR)
  return
end

-- 3. Iterate over all files in the directory
while true do
  local name, type = vim.loop.fs_scandir_next(handle)
  if not name then
    break
  end -- No more files

  -- 4. Check if it's a Lua file AND not init.lua
  if type == "file" and name:match("%.lua$") and name ~= "init.lua" then
    -- Strip the .lua extension
    local module_name = name:gsub("%.lua$", "")

    -- Dynamically require it
    local status_ok, fault = pcall(require, "frost.tools." .. module_name)
    if not status_ok then
      vim.notify(
        "Failed to load tool: " .. module_name .. "\n" .. tostring(fault),
        vim.log.levels.ERROR
      )
    end
  end
end
