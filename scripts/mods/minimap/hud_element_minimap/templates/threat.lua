local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local template = {}

template.create_widget_definition = function(settings, scenegraph_id)
    return UIWidget.create_definition({
        {
            pass_type = "texture_uv",
            value = "content/ui/materials/hud/interactions/icons/enemy",
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
                color = Color.ui_hud_red_light(255, true)
            }
        },
        {
            pass_type = "texture_uv",
            value = "content/ui/materials/hud/interactions/icons/attention",
            style_id = "icon_passive",
            style = {
                uvs = {
                    { 0.1, 0.1 },
                    { 0.9, 0.9 }
                },
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = settings.icon_size,
                color = { 255, 236, 165, 50 }
            }
        },
    }, scenegraph_id)
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
    local icon_passive = widget.style.icon_passive
    icon.offset[1] = x
    icon.offset[2] = y
    icon_passive.offset[1] = x
    icon_passive.offset[2] = y

    local visual_type = marker.data.visual_type or "default"
    if visual_type == "passive" then
        icon.visible = false
        icon_passive.visible = true
    else
        icon.visible = true
        icon_passive.visible = false
    end
end

return template
