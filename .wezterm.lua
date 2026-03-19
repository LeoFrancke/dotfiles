-- Pull in the wezterm API
local wezterm = require 'wezterm'
-- This will hold the configuration
local config = wezterm.config_builder()

-- Function to safely get system appearance
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'  -- Default to dark if no GUI context (e.g., mux server)
end

-- Function to select and customize scheme based on appearance
function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    -- Base on Dracula but override with darker bg and brighter fg
    return {
      colors = {
        background = '#0A0A0A',  -- Even darker than #121212
        foreground = '#FFFFFF',  -- Pure white
        cursor_bg = '#FFFFFF',
        cursor_fg = '#0A0A0A',
        selection_bg = '#585B70',  -- Gray for selections
        selection_fg = '#FFFFFF',
        ansi = {
          '#45475A', '#F38BA8', '#A6E3A1', '#F9E2AF',
          '#89B4FA', '#F5C2E7', '#94E2D5', '#D4D4D8'
        },
        brights = {
          '#585B70', '#FCA5A5', '#BFF0B3', '#FFE066',
          '#A3BFFA', '#F4C7E7', '#B0F0E0', '#FFFFFF'
        },
      },
    }
  else
    -- Light mode fallback (using Solarized Light as a base)
    return {
      color_scheme = 'Dracula',
    }
  end
end

-- Transparency
--config.window_background_opacity = 0.9
--config.text_background_opacity = 0.8

-- Font settings
config.font = wezterm.font_with_fallback({
  'Fira Code',        -- Preferred font
  'Noto Color Emoji', -- Fallback for emojis
})

config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.font_size = 12

-- Tab bar customization
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Keybindings
config.keys = {
  -- Open new tab
  { key = 't', mods = 'CTRL', action = wezterm.action { SpawnTab = 'CurrentPaneDomain' } },
  -- Close tab
  { key = 'q', mods = 'CTRL', action = wezterm.action { CloseCurrentTab = { confirm = true } } },
  -- Navigate tabs
  { key = 'Tab', mods = 'CTRL', action = wezterm.action { ActivateTabRelative = 1 } },
  { key = 'n', mods = 'CTRL', action = wezterm.action { ActivateTabRelative = 1 } },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = wezterm.action { ActivateTabRelative = -1 } },
  { key = 'p', mods = 'CTRL', action = wezterm.action { ActivateTabRelative = -1 } },
  -- Split panes
  { key = '"', mods = 'CTRL|SHIFT', action = wezterm.action { SplitHorizontal = { domain = 'CurrentPaneDomain' } } },
  { key = '%', mods = 'CTRL|SHIFT', action = wezterm.action { SplitVertical = { domain = 'CurrentPaneDomain' } } },
  -- Navigate panes
  { key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action { ActivatePaneDirection = 'Left' } },
  { key = 't', mods = 'CTRL|SHIFT', action = wezterm.action { ActivatePaneDirection = 'Down' } },
  { key = 'n', mods = 'CTRL|SHIFT', action = wezterm.action { ActivatePaneDirection = 'Up' } },
  { key = 's', mods = 'CTRL|SHIFT', action = wezterm.action { ActivatePaneDirection = 'Right' } },
}

-- Misc settings
config.scrollback_lines = 10000
config.enable_scroll_bar = true
config.window_padding = {
  left = 4,
  right = -5,
  top = 3,
  bottom = 0,
}

-- Merge the scheme into the config
local scheme = scheme_for_appearance(get_appearance())
for k, v in pairs(scheme) do
  config[k] = v
end

return config
