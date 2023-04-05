local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local template = {}

template.create_widget_definition = function(settings, scenegraph_id)
    return UIWidget.create_definition({
        {
            style_id = "icon",
            pass_type = "text",
            value_id = "icon_text",
            value = "",
            style = {
                horizontal_alignment = "center",
                vertical_alignment = "center",
                text_vertical_alignment = "center",
                text_horizontal_alignment = "center",
                drop_shadow = true,
                font_type = "proxima_nova_bold",
                font_size = 18,
                text_color = Color.ui_hud_green_light(255, true),
                default_text_color = Color.black(255, true),
                size = settings.icon_size
            }
        },
    }, scenegraph_id)
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
    icon.offset[1] = x
    icon.offset[2] = y

    local data = marker.data
    local player_slot = data:slot()
    icon.text_color = UISettings.player_slot_colors[player_slot] or icon.default_text_color

    local profile = data:profile()
    local archetype = profile and profile.archetype
    local string_symbol = archetype and archetype.string_symbol or ""
    local content = widget.content
    content.icon_text = string_symbol
end

return template
