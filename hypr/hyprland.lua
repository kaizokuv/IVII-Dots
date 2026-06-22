-- QT apps theme (force dark mode)
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "Breeze")

local ipc = "noctalia msg"

-- Startup
hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia")
	hl.exec_cmd("brave-browser")
	hl.exec_cmd("spotify")
end)

-- Blur effects
hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
	},
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

-- Keybinds

-- Launcher
hl.bind("SUPER + Tab", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))

-- Window switcher
-- hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher")) (WIP)

-- Cheatsheet

-- Settings
hl.bind("SUPER + I", hl.dsp.exec_cmd(ipc .. " settings-toggle"))

-- Clipboard
hl.bind("SUPER + V", hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))

-- Emojis
hl.bind("SUPER + Period", hl.dsp.exec_cmd(ipc .. " panel-toggle launcher '/emo'"))

-- Closing stuff
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Window: Forcefully zap a window" })

-- Control center
hl.bind("SUPER + N", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
hl.bind("SUPER + M", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center media"))
hl.bind("SUPER + A", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center audio"))
hl.bind("SUPER + Slash", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center notifications"))
hl.bind("CTRL + SUPER + B", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center bluetooth"))
hl.bind("CTRL + SUPER + W", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center network"))
hl.bind("CTRL + SUPER + S", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center system"))
hl.bind("CTRL + SUPER + C", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center calendar"))
hl.bind("SHIFT + SUPER + W", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center weather"))

-- Wallpaper
hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd(ipc .. " panel-toggle wallpaper"))
hl.bind("SUPER + ALT + T", hl.dsp.exec_cmd(ipc .. " wallpaper-random"))

-- Toggles
hl.bind("SHIFT + SUPER + C", hl.dsp.exec_cmd(ipc .. " caffeine-toggle"))
hl.bind("CTRL + SUPER + P", hl.dsp.exec_cmd(ipc .. " power-cycle"))
hl.bind("CTRL + SUPER + D", hl.dsp.exec_cmd(ipc .. " notification-dnd-toggle"))

-- Screenshot
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd(
		"hyprshot --freeze --mode region --silent --clipboard --output-folder ~/Pictures/Screenshots --filename screenshot_$(date +%Y%m%d_%H%M%S).png"
	)
)

-- Media keys and brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up 2"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down 2"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. " mic-mute"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. " media toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. " media next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. " media previous"), { locked = true })

-- Apps
hl.bind("SUPER + W", hl.dsp.exec_cmd("brave"), { description = "App: Browser" })
hl.bind("SUPER + Z", hl.dsp.exec_cmd("app.zen_browser.zen"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("spotify"))
hl.bind("SUPER + CTRL + V", hl.dsp.exec_cmd("vesktop"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("dolphin"), { description = "App: File manager" })

-- Kitty and stuff
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"), { description = "App: Terminal" })
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
-- hl.bind("SUPER + E", hl.dsp.exec_cmd("kitty -e /usr/bin/yazi"), { description = "App: File manager" })
hl.bind("SUPER + C", hl.dsp.exec_cmd("kitty -e nvim"), { description = "App: Code editor" })
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("kitty -e /home/kaizoku/.local/bin/late"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("kitty -e btop"))

-- Files
hl.bind("SUPER + H", hl.dsp.exec_cmd("kitty -e nvim ~/.config/hypr/hyprland.lua"))
hl.bind("CTRL + SUPER + F", hl.dsp.exec_cmd("kitty -e nvim ~/.config/fish/config.fish"))
hl.bind("SUPER + K", hl.dsp.exec_cmd("kitty -e nvim ~/.config/kitty/kitty.conf"))

-- For ricing screenshots
hl.bind("SHIFT + SUPER + Return", hl.dsp.exec_cmd("kitty --class floating-kitty"))
hl.bind("SHIFT + SUPER + T", hl.dsp.exec_cmd("kitty --class floating-kittyfm"))
hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd("kitty --class floating-kittyfm -e cava"))

-- Special
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("special"))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special", follow = true }))

-- Lock and session stuff
hl.bind("SUPER + L", hl.dsp.exec_cmd(ipc .. " session lock"))
hl.bind("CTRL + SHIFT + ALT + SUPER + Delete", hl.dsp.exec_cmd(ipc .. " session shutdown"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(ipc .. " panel-toggle session"))
hl.bind("SHIFT + SUPER + L", hl.dsp.exec_cmd(ipc .. " session logout"))
hl.bind("SHIFT + SUPER + R", hl.dsp.exec_cmd(ipc .. " session reboot"))

-- Window
-- Focusing
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })
-- bind = SUPER + ←/↑/→/↓,, -- Focus in direction
for i = 1, 6 do
	local arrowkey = { "Left", "Right", "Up", "Down", "BracketLeft", "BracketRight" }
	local focusdir = { "l", "r", "u", "d", "l", "r" }
	hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }))
end

-- bind = SUPER + SHIFT, ←/↑/→/↓,, -- Move in direction
for i = 1, 4 do
	local arrowkey = { "Left", "Right", "Up", "Down" }
	local focusdir = { "l", "r", "u", "d" }
	hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }))
end

-- Window split ratio
-- binde = SUPER, ;/',, -- Adjust split ratio
hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- Positioning mode
-- Float and center in one bind
hl.bind("SUPER + ALT + Space", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch centerwindow"))
end)
hl.bind(
	"SUPER + D",
	hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
	{ description = "Window: Maximize" }
)
hl.bind(
	"SUPER + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Window: Fullscreen" }
)
hl.bind("SHIFT + SUPER + P", hl.dsp.window.pin(), { description = "Window: Pin" })

-- bind = SUPER+ALT, Hash,, -- Send to workspace -- (2, 2, 3,...)
-- Send to workspace (number row)
for i = 1, 10 do
	local numberkey = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
	hl.bind("SUPER + ALT + code:" .. numberkey[i], hl.dsp.window.move({ workspace = i, follow = false }))
end
-- Send to workspace (numpad)
for i = 1, 10 do
	local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
	hl.bind("SUPER + ALT + code:" .. numpadkey[i], hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Workspace
-- Switching
-- bind = SUPER, Hash,, -- Focus workspace -- (1, 2, 3,...)
for i = 1, 10 do
	local numberkey = { 10, 11, 12, 13, 14, 15, 16, 17, 18, 19 }
	hl.bind("SUPER + code:" .. numberkey[i], hl.dsp.focus({ workspace = i }))
end
-- Focus workspace (numpad)
for i = 1, 10 do
	local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
	hl.bind("SUPER + code:" .. numpadkey[i], hl.dsp.focus({ workspace = i }))
end

-- bind = CTRL+SUPER, ←/→,, -- Focus left/right
for i = 1, 2 do
	local key = { "CTRL + SUPER + " }
	local keycombos = { key[1] .. "Right", key[1] .. "Left" }
	local prefix = { "r+", "r-" }
	hl.bind(keycombos[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }))
end

-- Window configs and stuff for designs and stuff (Copied fully from II)

-- MONITOR CONFIG
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

hl.gesture({
	fingers = 3,
	direction = "swipe",
	action = "move",
})
hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "workspace",
})

hl.config({
	gestures = {
		workspace_swipe_distance = 700,
		workspace_swipe_cancel_ratio = 0.2,
		workspace_swipe_min_speed_to_force = 5,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_create_new = true,
	},
	general = {
		-- Gaps and border
		gaps_in = 4,
		gaps_out = 5,
		gaps_workspaces = 50,

		border_size = 1,

		col = {
			active_border = "rgba(0DB7D455)",
			inactive_border = "rgba(31313600)",
		},
		resize_on_border = true,

		no_focus_fallback = true,
		allow_tearing = true, -- This just allows the `immediate` window rule to work
		snap = {
			enabled = true,
			window_gap = 4,
			monitor_gap = 5,
			respect_gaps = true,
		},
	},
	decoration = {
		-- 2 = circle, higher = squircle, 4 = very obvious squircle
		-- Fuck clearly visible squircles. 100% Apple brainrot.
		rounding_power = 2.5,
		rounding = 18,

		blur = {
			enabled = true,
			xray = true,
			special = false,
			new_optimizations = true,
			size = 10,
			passes = 3,
			brightness = 1,
			noise = 0.05,
			contrast = 0.89,
			vibrancy = 0.5,
			vibrancy_darkness = 0.5,
			popups = false,
			popups_ignorealpha = 0.6,
			input_methods = true,
			input_methods_ignorealpha = 0.8,
		},
		shadow = {
			enabled = true,
			range = 20,
			offset = { 0, 2 },
			render_power = 10,
			color = "rgba(00000020)",
		},
		-- Dim
		dim_inactive = true,
		dim_strength = 0.05,
		dim_special = 0.2,
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = false,
		-- precise_mouse_move = true,
	},
})
-- Curves
hl.curve("expressiveFastSpatial", {
	type = "bezier",
	points = { { 0.42, 1.67 }, { 0.21, 0.90 } },
})
hl.curve("expressiveSlowSpatial", {
	type = "bezier",
	points = { { 0.39, 1.29 }, { 0.35, 0.98 } },
})
hl.curve("expressiveDefaultSpatial", {
	type = "bezier",
	points = { { 0.38, 1.21 }, { 0.22, 1.00 } },
})
hl.curve("emphasizedDecel", {
	type = "bezier",
	points = { { 0.05, 0.7 }, { 0.1, 1 } },
})
hl.curve("emphasizedAccel", {
	type = "bezier",
	points = { { 0.3, 0 }, { 0.8, 0.15 } },
})
hl.curve("standardDecel", {
	type = "bezier",
	points = { { 0, 0 }, { 0, 1 } },
})
hl.curve("menu_decel", {
	type = "bezier",
	points = { { 0.1, 1 }, { 0, 1 } },
})
hl.curve("menu_accel", {
	type = "bezier",
	points = { { 0.52, 0.03 }, { 0.72, 0.08 } },
})
hl.curve("stall", {
	type = "bezier",
	points = { { 1, -0.1 }, { 0.7, 0.85 } },
})
-- Configs
-- windows
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
	style = "popin 80%",
})
hl.animation({
	leaf = "fadeIn",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 2,
	bezier = "emphasizedDecel",
	style = "popin 90%",
})
hl.animation({
	leaf = "fadeOut",
	enabled = true,
	speed = 2,
	bezier = "emphasizedDecel",
})
hl.animation({
	leaf = "windowsMove",
	enabled = true,
	speed = 3,
	bezier = "emphasizedDecel",
	style = "slide",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 10,
	bezier = "emphasizedDecel",
})

-- layers
hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 2.7,
	bezier = "emphasizedDecel",
	style = "popin 93%",
})
hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 2.4,
	bezier = "menu_accel",
	style = "popin 94%",
})
-- fade
hl.animation({
	leaf = "fadeLayersIn",
	enabled = true,
	speed = 0.5,
	bezier = "menu_decel",
})
hl.animation({
	leaf = "fadeLayersOut",
	enabled = true,
	speed = 2.7,
	bezier = "stall",
})
-- workspaces
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 7,
	bezier = "menu_decel",
	style = "slide",
})
-- specialWorkspace
hl.animation({
	leaf = "specialWorkspaceIn",
	enabled = true,
	speed = 2.8,
	bezier = "emphasizedDecel",
	style = "slidevert",
})
hl.animation({
	leaf = "specialWorkspaceOut",
	enabled = true,
	speed = 1.2,
	bezier = "emphasizedAccel",
	style = "slidevert",
})
-- zoom
hl.animation({
	leaf = "zoomFactor",
	enabled = true,
	speed = 3,
	bezier = "standardDecel",
})

hl.config({
	input = {
		kb_layout = "us",
		numlock_by_default = true,
		repeat_delay = 250,
		repeat_rate = 35,

		follow_mouse = 1,
		off_window_axis_events = 2,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.7,
		},
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty)",
		on_focus_under_fullscreen = 2,
		allow_session_lock_restore = true,
		session_lock_xray = true,
		initial_workspace_tracking = false,
		focus_on_activate = true,
	},

	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true,
	},

	cursor = {
		zoom_factor = 1,
		zoom_rigid = false,
		zoom_disable_aa = true,
		hotspot_padding = 1,
	},

	xwayland = {
		force_zero_scaling = true,
	},
})

-- For Noctalia Color templates
require("noctalia")

-- Disable blur for every window
hl.window_rule({ match = { class = ".*" }, no_blur = true })

-- App transparency
hl.window_rule({ match = { class = "Spotify" }, opacity = "0.8 override" })
hl.window_rule({ match = { class = "kitty" }, opacity = "0.8 override 0.65 override" })
hl.window_rule({ match = { class = "floating-kitty" }, opacity = "0.8 override 0.65 override" })
hl.window_rule({ match = { class = "floating-kittyfm" }, opacity = "0.8 override 0.65 override" })
hl.window_rule({ match = { class = "vesktop" }, opacity = "0.9 override" })
hl.window_rule({ match = { class = "steam" }, opacity = "0.9 override" })

-- Floating kitty
hl.window_rule({
	match = { class = "floating-kitty" },
	float = true,
	center = true,
	size = "1000 600",
})

-- Floating kitty (follow mouse)
hl.window_rule({
	match = { class = "floating-kittyfm" },
	float = true,
	size = "900 500",
	move = { "cursor_x-(window_w*0.5)", "cursor_y-(window_h*0.5)" },
})

-- Spotify
hl.window_rule({
	match = { class = "Spotify" },
	workspace = 2,
})

-- Brave
hl.window_rule({
	match = { class = "brave-browser" },
	workspace = 1,
})
