local wezterm = require 'wezterm'
local config = {
    -- Keybindings
    keys = {
        -- Basick keys
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
            -- We need to copy to CLIPBOARD only! Never use "ClipboardAndPrimarySelection".
            --
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },
        { key = "F11", action = wezterm.action.ToggleFullScreen },
        -- Fixing Ctrl+backspace not working in vim:
        { key = 'Backspace', mods = 'CTRL', action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' } },

        -- Navigation
        -- to-do

    },

    -- Style
    default_cursor_style = "BlinkingBlock",
    window_background_opacity = 0.91,
    window_decorations = "RESIZE",
    font_size = 14.0,
    font = wezterm.font_with_fallback({
        { 
            -- family = "JetBrainsMono", --weight = 400,
            family = "Fira Code", --weight = 400,
            -- Stylistic Sets // Character Variants:
            harfbuzz_features = {
                -- Fira Code 1234567890
                -- 'zero',   -- Zero: dot || line
                'cv04',      -- i: cv03..06
                'cv14',      -- 3
                'ss02',      -- <= >=
                'ss03',      -- &
                -- 'ss04',      -- $
                'ss05',      -- @
                'cv16',      -- *
                -- 'cv18',      -- %
                'ss06',      -- \\
                'ss07',      -- =~ !~ 
                'ss10',      -- fi fj fl ft Fl Tl  
                'cv31',      -- ()
                'cv30',      -- |
                -- 'onum',      -- 1111 2222 3333 6666 7777
            },
        },
        -- Fallback font
        "Symbols Nerd Font Mono", -- icons
        "Noto Color Emoji",
    }),

    -- Padding
    window_padding = {
        left = 8,
        right = 6,
        top = 11,
        bottom = 5,
    },

    -- Inactive pane styling
    inactive_pane_hsb = {
        hue = 1.0,        -- Keep hue unchanged (1.0 = default)
        saturation = 0.8, -- Slightly desaturated (less vibrant)
        brightness = 0.4, -- Dimmer than active pane
    },

    -- Tab bar settings
    tab_bar_at_bottom = false,
    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = true,
}

return config

