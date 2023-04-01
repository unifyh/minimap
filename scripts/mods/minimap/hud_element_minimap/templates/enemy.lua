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

local function show_all(widget, marker, x, y)
    return
end

local function show_when_healthbar_visible(widget, marker, x, y)
    widget.alpha_multiplier = marker.widget.alpha_multiplier -- LoS fading
    widget.style.icon.visible = marker.draw and not not HEALTH_ALIVE[marker.unit]
end

local function show_damaged(widget, marker, x, y)
    local unit = marker.unit
    local is_alive = not not HEALTH_ALIVE[unit]
    local health_extension = ScriptUnit.has_extension(unit, "health_system")
    local taken_damage = health_extension and (health_extension:total_damage_taken() > 0) or false
    widget.style.icon.visible = is_alive and taken_damage
end

template.update_function = function(widget, marker, x, y)
    local icon = widget.style.icon
    icon.offset[1] = x
    icon.offset[2] = y
    
    show_damaged(widget, marker, x, y)
end

return template
