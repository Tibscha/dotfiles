-- -- Pull in the wezterm API
-- local wezterm = require("wezterm")
--
-- -- This will hold the configuration.
-- local config = wezterm.config_builder()
-- config.default_prog = { "/bin/zsh", "-l" }
--
-- -- This is where you actually apply your config choices.
--
-- -- For example, changing the initial geometry for new windows:
-- --config.initial_cols = 120
-- --config.initial_rows = 28
--
-- -- or, changing the font size and color scheme.
-- config.font_size = 11
-- config.color_scheme = "Catppuccin Mocha"
-- config.font = wezterm.font("JetBrains Mono")
-- config.window_background_opacity = 0.8
-- config.hide_tab_bar_if_only_one_tab = true
-- config.window_decorations = "RESIZE"
-- config.use_fancy_tab_bar = false
-- config.window_frame = {
-- 	inactive_titlebar_bg = "none",
-- 	active_titlebar_bg = "none",
-- }
-- --config.window_background_gradient = {
-- --  colors = { "#000000" },
-- --}
-- config.show_new_tab_button_in_tab_bar = false
-- --config.show_close_tab_button_in_tab_bar = false
-- config.colors = {
-- 	tab_bar = {
-- 		inactive_tab_edge = "none",
-- 	},
-- }
-- local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
--
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local background = "#5c6d74"
-- 	local foreground = "#FFFFFF"
-- 	local edge_background = "none"
-- 	if tab.is_active then
-- 		background = "#ae8b2d"
-- 		foreground = "#FFFFFF"
-- 	end
-- 	local edge_foreground = background
-- 	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
-- 	return {
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 		{ Text = SOLID_LEFT_ARROW },
-- 		{ Background = { Color = background } },
-- 		{ Foreground = { Color = foreground } },
-- 		{ Text = title },
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 		{ Text = SOLID_RIGHT_ARROW },
-- 	}
-- end)
-- config.keys = {
-- 	{
-- 		key = "w",
-- 		mods = "CMD",
-- 		action = wezterm.action.CloseCurrentTab({ confirm = false }),
-- 	},
-- }
--
-- config.skip_close_confirmation_for_processes_named = {
-- 	"bash",
-- 	"sh",
-- 	"zsh",
-- 	"fish",
-- 	"tmux",
-- 	"nu",
-- 	"cmd.exe",
-- 	"pwsh.exe",
-- 	"powershell.exe",
-- }
-- -- Finally, return the configuration to wezterm:
-- return config
--
local wezterm = require("wezterm")
return {
	adjust_window_size_when_changing_font_size = false,
	-- color_scheme = 'termnial.sexy',
	color_scheme = "Catppuccin Mocha",
	enable_tab_bar = false,
	font_size = 13.0,
	font = wezterm.font("JetBrains Mono"),
	-- macos_window_background_blur = 40,
	macos_window_background_blur = 30,

	-- window_background_image = '/Users/omerhamerman/Downloads/3840x1080-Wallpaper-041.jpg',
	-- window_background_image_hsb = {
	-- 	brightness = 0.01,
	-- 	hue = 1.0,
	-- 	saturation = 0.5,
	-- },
	-- window_background_opacity = 0.92,
	-- window_background_opacity = 1.0,
	window_background_opacity = 0.78,
	-- window_background_opacity = 0.20,
	window_decorations = "RESIZE",
	keys = {
		{
			key = "q",
			mods = "CTRL",
			action = wezterm.action.ToggleFullScreen,
		},
		{
			key = "'",
			mods = "CTRL",
			action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
}
