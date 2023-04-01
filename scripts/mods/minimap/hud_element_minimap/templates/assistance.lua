local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local template = {}

template.create_widget_definition = function(settings, scenegraph_id)
    return UIWidget.create_definition({
        {
            pass_type = "texture",
            value = "content/ui/materials/hud/icons/player_assistance/player_assistance_icon",
            style_id = "icon",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 1, 1 },
                default_offset = { 0, 1, 1 },
                size = {
                    settings.icon_size[1] / 4,
                    settings.icon_size[2] / 2,
                },
                color = Color.ui_hud_green_super_light(255, true)
            }
        },
        {
            pass_type = "texture",
            value = "content/ui/materials/hud/icons/player_assistance/player_assistance_frame",
            style_id = "frame",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = {
                    settings.icon_size[1],
                    settings.icon_size[2] * 0.9,
                },
                color = { 255, 236, 50, 50 }
            }
        },
    }, scenegraph_id)
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
    local frame = widget.style.frame
    icon.offset[1] = x + icon.default_offset[1]
    icon.offset[2] = y + icon.default_offset[2]
    frame.offset[1] = x
    frame.offset[2] = y
end

return template
