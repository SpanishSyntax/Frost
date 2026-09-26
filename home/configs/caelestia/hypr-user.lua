-- -------------------------------------------------------------
-- Execution & Imports
-- -------------------------------------------------------------

hl.config({
  input = {
    kb_layout = "us,latam",
    kb_options = "grp:win_space_toggle, ctrl:swapcaps",
    sensitivity = 0.5,
    follow_mouse = 1,
  },
})

hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60",
  position = "auto",
  scale = 1,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@60",
  position = "auto",
  scale = 1,
})

hl.on("hyprland.start", function()
  hl.exec_cmd("iio-hyprland")
end)

hl.bind("SUPER + W", hl.dsp.exec_cmd("zapzap"))
