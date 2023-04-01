local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local template = {}

template.create_widget_definition = function(settings, scenegraph_id)
    return UIWidget.create_definition({
        {
            pass_type = "texture",
            value = "content/ui/materials/backgrounds/default_square",
            style_id = "icon",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = settings.icon_size,
                color = UIHudSettings.color_tint_main_1
            }
        },
    }, scenegraph_id)
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
    icon.offset[1] = x
    icon.offset[2] = y
end

return template
