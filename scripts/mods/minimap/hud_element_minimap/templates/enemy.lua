local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local template = {}

template.create_widget_definition = function(settings, scenegraph_id)
    return UIWidget.create_definition({
        {
            pass_type = "texture_uv",
            value = "content/ui/materials/hud/interactions/icons/default",
            style_id = "icon",
            style = {
                uvs = {
                    { 0.1, 0.1 },
                    { 0.9, 0.9 }
                },
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = settings.icon_size,
                color = Color.dark_red(255, true)
            }
        },
    }, scenegraph_id)
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
	icon.offset[1] = x
	icon.offset[2] = y
    
    widget.alpha_multiplier = marker.widget.alpha_multiplier -- LoS fading
    widget.style.icon.visible = marker.draw and not not HEALTH_ALIVE[marker.unit]
end

return template
