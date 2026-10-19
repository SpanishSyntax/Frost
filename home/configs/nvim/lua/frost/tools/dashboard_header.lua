-- lua/frost/tools/dashboard_header.lua
local M = {}

M.ascii_header = [[
  ███████╗██████╗  ██████╗ ███████╗████████╗
  ██╔════╝██╔══██╗ ██╔═══██╗██╔════╝╚══██╔══╝
  █████╗  ██████╔╝ ██║   ██║███████╗   ██║   
  ██╔══╝  ██╔══██╗ ██║   ██║╚════██║   ██║   
  ██║     ██║  ██║ ╚██████╔╝███████║   ██║   
  ╚═╝     ╚═╝  ╚═╝  ╚═════╝ ╚══════╝   ╚═╝   ]]

local function get_capabilities()
  local png_path = vim.g.frost_logo_png or ""
  local svg_path = vim.g.frost_logo_svg or ""

  local target_file = ""
  if png_path ~= "" and vim.fn.filereadable(png_path) == 1 then
    target_file = png_path
  elseif svg_path ~= "" and vim.fn.filereadable(svg_path) == 1 then
    target_file = svg_path
  end

  return {
    file = target_file,
    has_file = target_file ~= "",
    has_chafa = vim.fn.executable("chafa") == 1,
  }
end

-- Resolve active mode ("symbols" | "ascii")
function M.get_mode()
  local mode = vim.g.frost_dashboard_logo_mode
  if not mode then
    local caps = get_capabilities()
    if caps.has_file and caps.has_chafa then
      mode = "symbols"
    else
      mode = "ascii"
    end
    vim.g.frost_dashboard_logo_mode = mode
  end
  return mode
end

-- Generate header section cleanly
local function get_header_section(mode)
  local caps = get_capabilities()

  -- Mode 1: High-Fidelity Terminal Symbols (ANSI RGB Block characters)
  if mode == "symbols" and caps.has_file and caps.has_chafa then
    local cmd = string.format(
      "chafa --format=symbols --symbols=all --color-space=rgb --size=58x15 --align=center %s",
      vim.fn.shellescape(caps.file)
    )
    return {
      section = "terminal",
      id = "header_symbols", -- Explicit ID prevents terminal buffer caching bugs
      cmd = cmd,
      height = 15,
      width = 58,
      align = "center",
      padding = 1,
      ttl = 5 * 60,
    }
  end

  -- Mode 2: Classic ASCII Banner Fallback
  return {
    section = "header",
    padding = 1,
  }
end

-- Builds the complete sections array for Snacks.dashboard
function M.build_sections(mode)
  mode = mode or M.get_mode()
  return {
    get_header_section(mode),
    {
      section = "keys",
      gap = 1,
      padding = 1,
    },
    { section = "startup" },
  }
end

-- Reloads the current Snacks dashboard cleanly
local function refresh_dashboard(new_mode)
  vim.g.frost_dashboard_logo_mode = new_mode

  local ok, Snacks = pcall(require, "snacks")
  if not ok then
    return
  end

  local new_sections = M.build_sections(new_mode)

  -- Update global config so it persists on fresh splits/tabs
  if Snacks.config and Snacks.config.dashboard then
    Snacks.config.dashboard.sections = new_sections
  end

  -- Clean up current dashboard buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "snacks_dashboard" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end

  -- Open and forcefully override the instance options
  Snacks.dashboard.open({
    sections = new_sections,
  })

  vim.notify("Dashboard header set to: " .. new_mode, vim.log.levels.INFO, { title = "Frost UI" })
end

-- Interactive Snacks Picker selector
function M.select_style()
  local ok, Snacks = pcall(require, "snacks")

  local items = {
    {
      idx = 1,
      id = "symbols",
      title = "High-Fidelity Symbols",
      desc = "Chafa full Unicode braille/block characters",
      icon = "🔲",
    },
    {
      idx = 2,
      id = "ascii",
      title = "ASCII Text Header",
      desc = "Standard theme-colored text banner",
      icon = "📝",
    },
  }

  if ok and Snacks.picker then
    Snacks.picker({
      title = "Frost Dashboard Header Style",
      items = items,
      format = function(item)
        return {
          { item.icon .. "  ", "Special" },
          { item.title, "DiagnosticInfo" },
          { " — " .. item.desc, "Comment" },
        }
      end,
      confirm = function(picker, item)
        picker:close()
        if item and item.id then
          refresh_dashboard(item.id)
        end
      end,
    })
    return
  end

  vim.ui.select(items, {
    prompt = "Select Dashboard Header Style:",
    format_item = function(item)
      return string.format("%s %s (%s)", item.icon, item.title, item.desc)
    end,
  }, function(choice)
    if choice then
      refresh_dashboard(choice.id)
    end
  end)
end

-- User Command & Keymap
vim.api.nvim_create_user_command("FrostSelectHeaderStyle", M.select_style, {
  desc = "Switch Frost dashboard logo header style",
})

vim.keymap.set("n", "<leader>ud", M.select_style, {
  desc = "Frost: Select Dashboard Header Style",
  silent = true,
})

return M
