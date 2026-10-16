-- lua/frost/tools/dashboard_header.lua
local M = {}

M.ascii_header = [[
  ███████╗██████╗   ██████╗ ███████╗████████╗
  ██╔════╝██╔══██╗ ██╔═══██╗██╔════╝╚══██╔══╝
  █████╗  ██████╔╝ ██║   ██║███████╗   ██║   
  ██╔══╝  ██╔══██╗ ██║   ██║╚════██║   ██║   
  ██║     ██║  ██║ ╚██████╔╝███████║   ██║   
  ╚═╝     ╚═╝  ╚═╝  ╚═════╝ ╚══════╝   ╚═╝   ]]

local function get_capabilities()
  local logo_path = vim.g.frost_logo_svg or ""
  local has_logo = logo_path ~= "" and vim.fn.filereadable(logo_path) == 1
  local has_chafa = vim.fn.executable("chafa") == 1

  return {
    path = logo_path,
    has_logo = has_logo,
    has_chafa = has_chafa,
  }
end

-- Resolve the active mode ("symbols" | "ascii")
function M.get_mode()
  local mode = vim.g.frost_dashboard_logo_mode
  if not mode then
    local caps = get_capabilities()
    mode = (caps.has_logo and caps.has_chafa) and "symbols" or "ascii"
    vim.g.frost_dashboard_logo_mode = mode
  end
  return mode
end

-- Generate header section cleanly
local function get_header_section(mode)
  local caps = get_capabilities()

  -- Symbols mode: use Snacks native terminal section with a solid TTL
  if (mode == "symbols" or mode == "image") and caps.has_logo and caps.has_chafa then
    local cmd = string.format(
      "chafa --format=symbols --symbols=vhalf+block --color-space=din99d --size=58x10 %s",
      vim.fn.shellescape(caps.path)
    )
    return {
      section = "terminal",
      cmd = cmd,
      height = 10,
      width = 58,
      align = "center",
      padding = 1,
      ttl = 5 * 60, -- Keeps the rendered terminal output cached for 5 minutes (prevents exit flash)
    }
  end

  -- ASCII mode fallback (uses the built-in Snacks header parser)
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

-- Interactive selector
function M.select_style()
  local options = {
    { id = "symbols", label = "Terminal Chafa (Block & Half-Block Symbols)" },
    { id = "ascii", label = "ASCII Plain Text (Theme Colored)" },
  }

  vim.ui.select(options, {
    prompt = "Select Dashboard Header Style:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end

    vim.g.frost_dashboard_logo_mode = choice.id

    local ok, Snacks = pcall(require, "snacks")
    if ok and Snacks.config and Snacks.config.dashboard then
      Snacks.config.dashboard.sections = M.build_sections(choice.id)

      if vim.bo.filetype == "snacks_dashboard" then
        vim.cmd("bd!")
      end

      Snacks.dashboard.open()
      vim.notify(
        "Dashboard header set to: " .. choice.id,
        vim.log.levels.INFO,
        { title = "Frost UI" }
      )
    end
  end)
end

-- User Command
vim.api.nvim_create_user_command("FrostSelectHeaderStyle", M.select_style, {
  desc = "Switch Frost dashboard logo header style",
})

-- Keymap (Self-contained in tool)
vim.keymap.set("n", "<leader>uh", M.select_style, {
  desc = "Frost: Select Dashboard Header Style",
  silent = true,
})

return M
