local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local template = {}

template.create_widget_definition = function(settings, scenegraph_id)
    return UIWidget.create_definition({
        {
            pass_type = "texture_uv",
            value_id = "icon",
            value = "content/ui/materials/hud/interactions/icons/pocketable_default",
            style_id = "icon",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 1 },
                size = {
                    settings.icon_size[1] * 0.9,
                    settings.icon_size[2] * 0.9
                },
                default_color = Color.ui_hud_green_super_light(255, true),
                color = Color.ui_hud_green_super_light(255, true)
            }
        },
        {
            pass_type = "texture_uv",
            value = "content/ui/materials/hud/interactions/frames/mission_top",
            style_id = "ring",
            style = {
                uvs = {
                    { 0.2, 0.2 },
                    { 0.8, 0.8 }
                },
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = settings.icon_size,
                color = Color.ui_input_color(255, true)
            }
        },
    }, scenegraph_id)
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
    icon.offset[1] = x
    icon.offset[2] = y
    local ring = widget.style.ring
    ring.offset[1] = x
    ring.offset[2] = y

    local interaction_icon = marker.data:interaction_icon()
    widget.content.icon = interaction_icon

    local is_book = interaction_icon == "content/ui/materials/hud/interactions/icons/pocketable_default"

    local is_tagged = marker.template.get_smart_tag_id(marker) ~= nil
    icon.visible = is_tagged
    ring.visible = is_tagged
end

return template
