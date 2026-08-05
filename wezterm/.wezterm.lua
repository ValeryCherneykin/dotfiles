-- WezTerm config
-- WezTerm is just a window for tmux, nothing more

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Kanagawa Dragon
config.colors = {
    foreground = "#dcd7ba",
    background = "#0d0c0c",
    cursor_bg = "#c8c093",
    cursor_fg = "#0d0c0c",
    cursor_border = "#c8c093",
    selection_fg = "#dcd7ba",
    selection_bg = "#2d4f67",
    scrollbar_thumb = "#16161d",
    split = "#16161d",
    ansi = { "#0d0c0c", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
    brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
}

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 13.5
config.line_height = 1.0
config.cell_width = 1.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_background_opacity = 0.90

config.default_cursor_style = "SteadyBlock"
config.enable_tab_bar = false

config.front_end = "Software"
config.max_fps = 60
config.animation_fps = 1
config.enable_wayland = false
config.scrollback_lines = 10000

config.audible_bell = "Disabled"
config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }

config.default_prog = { "/usr/bin/zsh", "-l" }

local act = wezterm.action
config.keys = {
    { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
    { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
    { key = "n", mods = "CTRL|SHIFT", action = act.SpawnWindow },
    { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = false }) },
    { key = "q", mods = "CTRL|SHIFT", action = act.QuitApplication },
    { key = "Enter", mods = "CTRL|SHIFT", action = act.ToggleFullScreen },
    { key = "=", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL|SHIFT", action = act.DecreaseFontSize },
    { key = "0", mods = "CTRL|SHIFT", action = act.ResetFontSize },
}

config.check_for_updates = false
return config
