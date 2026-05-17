----------------
-- MONITORS
----------------

hl.monitor({
  output = "eDP-1",
  mode = "1920x1080@60",
  position = "0x0",
  scale = 1.0,
})

-- External monitor, currently disabled:
-- hl.monitor({
--   output = "HDMI-A-1",
--   mode = "1920x1080@60",
--   position = "1920x0",
--   scale = 1.0,
-- })

----------------
-- PROGRAMS
----------------

local home = os.getenv("HOME") or "/home/raviroy"
local hypr_config = home .. "/.config/hypr"
local scripts = home .. "/.scripts"

local terminal = "kitty"
local floatingterminal = "wezterm"
local fileManager = "dolphin"
local menu = "wofi --show drun"

----------------
-- AUTOSTART
----------------

hl.on("hyprland.start", function()
  hl.exec_cmd(home .. "/02-Applications/pCloud.AppImage")
  hl.exec_cmd("kdeconnectd & kdeconnect-indicator")
  hl.exec_cmd("firefox")
  -- hl.exec_cmd("flatpak run app.zen_browser.zen")
  hl.exec_cmd("mako & hypridle")
  hl.exec_cmd(home .. "/.config/waybar/waybar-auto.sh")
  hl.exec_cmd("flatpak run com.ticktick.TickTick")
  hl.exec_cmd("thunderbird")
  hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")
  hl.exec_cmd(hypr_config .. "/scripts/random_wallpaper.sh")
  hl.exec_cmd(scripts .. "/check_battery2.py")
  hl.exec_cmd("udiskie")
end)

--------------------------
-- ENVIRONMENT VARIABLES
--------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

----------------
-- LOOK AND FEEL
----------------

hl.config({
  general = {
    gaps_in = 4,
    gaps_out = 4,
    border_size = 2,

    col = {
      active_border = {
        colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
        angle = 45,
      },
      inactive_border = "rgba(595959aa)",
    },

    resize_on_border = true,
    allow_tearing = false,
    layout = "scrolling",
  },

  scrolling = {
      fullscreen_on_one_column = true,
      column_width = 0.82,
      focus_fit_method = 1,
      follow_focus = true,
      follow_min_visible = 0.4,
      explicit_column_widths = "0.5, 0.667, 0.82, 1.0",
      wrap_focus = true,
      wrap_swapcol = true,
      direction = "right",
    },

  decoration = {
    rounding = 10,

    active_opacity = 1.0,
    inactive_opacity = 0.95,

    blur = {
     enabled = true,
     size = 3,
     passes = 2,
     vibrancy = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },

  master = {
    new_status = "master",
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
  },

  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_rules = "",
    kb_options = "caps:swapescape",

    follow_mouse = 1,
    sensitivity = 0,

    touchpad = {
      natural_scroll = true,
    },
  },

  group = {
    groupbar = {
      col = {
        active = 0xfcf5c2e7,
        inactive = 0xfc585b70,
      },
      height = 24,
      font_size = 14,
      rounding = 4,
    },
  },
})

----------------
-- ANIMATIONS
----------------

hl.curve("myBezier", {
  type = "bezier",
  points = {
    { 0.05, 0.9 },
    { 0.1, 1.05 },
  },
})

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

----------------
-- INPUT EXTRAS
----------------

-- -- dwindle
-- hl.gesture({
--   fingers = 3,
--   direction = "horizontal",
--   action = "workspace",
-- })

-- Switch workspace by 4 finger gesture
hl.gesture({
  fingers = 4,
  direction = "horizontal",
  action = "workspace",
})

-- Scrolling by gesture
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "scroll_move",
})

hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})

----------------
-- KEYBINDINGS
----------------

local mainMod = "SUPER"
local altMod = "ALT"
local superShift = "SUPER + SHIFT"
local altShift = "ALT + SHIFT"
local ctrlShift = "CTRL + SHIFT"

-- Applications and general window controls
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(superShift .. " + X", hl.dsp.exit())
hl.bind(mainMod .. " + Space", hl.dsp.window.float())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(altMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region"))

hl.bind(superShift .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("killall wlogout || wlogout"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("gnome-calculator"))
hl.bind(mainMod .. " + grave", hl.dsp.focus({ last = true }))
hl.bind(mainMod .. " + BackSpace", hl.dsp.focus({ urgent_or_last = true }))

-- ALT binds
hl.bind(altMod .. " + Return", hl.dsp.exec_cmd(floatingterminal))
hl.bind(altMod .. " + D", hl.dsp.exec_cmd(fileManager))
hl.bind(altMod .. " + Tab", hl.dsp.exec_cmd(hypr_config .. "/scripts/hidden_windows.sh --click"))

-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspaces: SUPER + number -> 1-10
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Workspaces: ALT + number -> 11-20
for i = 1, 9 do
  hl.bind(altMod .. " + " .. i, hl.dsp.focus({ workspace = i + 10 }))
end
hl.bind(altMod .. " + 0", hl.dsp.focus({ workspace = 20 }))

-- Extra workspace switches: SUPER
hl.bind(mainMod .. " + W", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + E", hl.dsp.focus({ workspace = 1 })) -- firefox
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = 2 })) -- terminal
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = 3 })) -- dolphin
hl.bind(mainMod .. " + Z", hl.dsp.focus({ workspace = 4 })) -- Zotero

-- Extra workspace switches: ALT
hl.bind(altMod .. " + W", hl.dsp.focus({ workspace = 20 }))
hl.bind(altMod .. " + E", hl.dsp.focus({ workspace = 11 })) -- thunderbird
hl.bind(altMod .. " + A", hl.dsp.focus({ workspace = 12 })) -- second terminal
hl.bind(altMod .. " + S", hl.dsp.focus({ workspace = 13 })) -- ticktick/calendar
hl.bind(altMod .. " + Z", hl.dsp.focus({ workspace = 14 })) -- okular

-- Move active window to workspace: SUPER + SHIFT + number -> 1-10
for i = 1, 9 do
  hl.bind(superShift .. " + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(superShift .. " + 0", hl.dsp.window.move({ workspace = 10 }))

-- Move active window to workspace: ALT + SHIFT + number -> 11-20
for i = 1, 9 do
  hl.bind(altShift .. " + " .. i, hl.dsp.window.move({ workspace = i + 10 }))
end
hl.bind(altShift .. " + 0", hl.dsp.window.move({ workspace = 20 }))

-- Extra move-to-workspace keys: SUPER + SHIFT
hl.bind(superShift .. " + W", hl.dsp.window.move({ workspace = 10 }))
hl.bind(superShift .. " + E", hl.dsp.window.move({ workspace = 1 })) -- firefox
hl.bind(superShift .. " + A", hl.dsp.window.move({ workspace = 2 })) -- terminal
hl.bind(superShift .. " + S", hl.dsp.window.move({ workspace = 3 })) -- dolphin
hl.bind(superShift .. " + Z", hl.dsp.window.move({ workspace = 4 })) -- Zotero

-- Extra move-to-workspace keys: ALT + SHIFT
hl.bind(altShift .. " + W", hl.dsp.window.move({ workspace = 20 }))
hl.bind(altShift .. " + E", hl.dsp.window.move({ workspace = 11 })) -- thunderbird
hl.bind(altShift .. " + A", hl.dsp.window.move({ workspace = 12 })) -- second terminal
hl.bind(altShift .. " + S", hl.dsp.window.move({ workspace = 13 })) -- ticktick/calendar
hl.bind(altShift .. " + Z", hl.dsp.window.move({ workspace = 14 })) -- okular

-- Special workspaces / scratchpads
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("general"))
hl.bind(superShift .. " + M", hl.dsp.window.move({ workspace = "special:general" }))

hl.bind(mainMod .. " + B", hl.dsp.workspace.toggle_special("term"))
hl.bind(superShift .. " + B", hl.dsp.window.move({ workspace = "special:term" }))

hl.bind(mainMod .. " + N", hl.dsp.workspace.toggle_special("notes"))
hl.bind(superShift .. " + N", hl.dsp.window.move({ workspace = "special:notes" }))

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(ctrlShift .. " + W", hl.dsp.exec_cmd(hypr_config .. "/scripts/restart-waybar.sh"))

-- Workspace scrolling
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with SUPER + mouse buttons
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move using tab
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(superShift .. " + Tab", hl.dsp.focus({ workspace = "m-1" }))

-- Shift current workspace to monitor left/right
hl.bind(superShift .. " + left", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(superShift .. " + right", hl.dsp.workspace.move({ monitor = "r" }))

-- Grouped window controls
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind("CTRL + Tab", hl.dsp.group.next())
hl.bind(ctrlShift .. " + Tab", hl.dsp.group.prev())
hl.bind(superShift .. " + G", hl.dsp.window.move({ out_of_group = true }))


-- Scrolling layout controls
hl.bind(mainMod .. " + period", hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + comma", hl.dsp.layout("move -col"))

hl.bind(superShift .. " + period", hl.dsp.layout("swapcol r"))
hl.bind(superShift .. " + comma", hl.dsp.layout("swapcol l"))

hl.bind("SUPER + CTRL + period", hl.dsp.layout("colresize +conf"))
hl.bind("SUPER + CTRL + comma", hl.dsp.layout("colresize -conf"))

hl.bind(mainMod .. " + slash", hl.dsp.layout("fit active"))
hl.bind(superShift .. " + slash", hl.dsp.layout("fit all"))

hl.bind(mainMod .. " + semicolon", hl.dsp.layout("consume_or_expel next"))

-- Laptop multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })

-- Player controls
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-------------------------
-- WINDOWS AND WORKSPACES
-------------------------

hl.window_rule({
  name = "windowrule-1",
  match = { class = [[^(org\.wezfurlong\.wezterm)$]] },
  float = true,
  size = { 1200, 800 },
})

hl.window_rule({
  name = "windowrule-2",
  match = { class = [[^(org.gnome.Calendar)$]] },
  float = true,
  size = { 600, 400 },
})

hl.window_rule({
  name = "windowrule-3",
  match = { class = [[^(eog)$]] },
  float = true,
})

hl.window_rule({
  name = "windowrule-4",
  match = { class = [[^(xpad)$]] },
  float = true,
  size = { 400, 600 },
})

hl.window_rule({
  name = "windowrule-5",
  match = { class = [[^(featherpad)$]] },
  float = true,
  size = { 1200, 800 },
})

hl.window_rule({
  name = "windowrule-6",
  match = { class = [[^(org.gnome.Calculator)$]] },
  float = true,
})

hl.window_rule({
  name = "windowrule-7",
  match = { class = [[^(org.kde.knotes)$]] },
  float = true,
  size = { 400, 400 },
})

hl.window_rule({
  name = "windowrule-8",
  match = { class = [[^(io.github.nokse22.minitext)$]] },
  float = true,
  size = { 1200, 600 },
})

-- Needed for blur background in wlogout
hl.layer_rule({
  name = "layerrule-1",
  match = { namespace = "logout_dialog" },
  blur = true,
})

-- Ignore maximize requests from apps
hl.window_rule({
  name = "windowrule-9",
  match = { class = [[.*]] },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
  name = "windowrule-10",
  match = {
    class = [[^$]],
    title = [[^$]],
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})

-- Open apps in dedicated workspaces
hl.window_rule({
  name = "windowrule-11",
  match = { class = [[^(org\.mozilla\.firefox)$]] },
  workspace = "1",
})

-- Zen browser rule, currently disabled:
-- hl.window_rule({
--   name = "windowrule-zen",
--   match = { class = [[^(app\.zen_browser\.zen)$]] },
--   workspace = "1",
-- })

hl.window_rule({
  name = "windowrule-12",
  match = { class = [[^(org\.kde\.dolphin)$]] },
  workspace = "3",
})

hl.window_rule({
  name = "windowrule-13",
  match = { class = [[^(Zotero)$]] },
  workspace = "4",
})

hl.window_rule({
  name = "windowrule-14",
  match = { class = [[^(net\.thunderbird\.Thunderbird)$]] },
  workspace = "11",
})

hl.window_rule({
  name = "windowrule-15",
  match = { class = [[^(ticktick)$]] },
  workspace = "13",
})

hl.window_rule({
  name = "windowrule-16",
  match = { class = [[^(org\.kde\.okular)$]] },
  workspace = "14",
})
