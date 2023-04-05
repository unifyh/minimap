local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local settings = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/hud_element_minimap_settings")

local scenegraph_definition = {
    screen = UIWorkspaceSettings.screen,
    minimap = {
        parent = "screen",
        vertical_alignment = "center",
        horizontal_alignment = "left",
        size = settings.size,
        position = { 50, -100, 10 },
    },
}

local widget_definitions = {
    background = UIWidget.create_definition({
        {
            pass_type = "circle",
            style_id = "circ",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, 0, -2 },
                size = {
                    settings.radius * 2,
                    settings.radius * 2
                },
                color = Color.ui_grey_medium(64, true)
            }
        },
    }, "minimap"),
    fov_indicator = UIWidget.create_definition({
        {
            value = "content/ui/materials/dividers/divider_line_01",
            pass_type = "rotated_texture",
            style_id = "fov_left",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, -settings.radius / 2, -1 },
                size = { 2, settings.radius },
                pivot = {
                    1,
                    settings.radius
                },
                angle = math.pi / 6,
                color = Color.ui_grey_light(64, true)
            }
        },
        {
            value = "content/ui/materials/dividers/divider_line_01",
            pass_type = "rotated_texture",
            style_id = "fov_right",
            style = {
                vertical_alignment = "center",
                horizontal_alignment = "center",
                offset = { 0, -settings.radius / 2, -1 },
                size = { 2, settings.radius },
                pivot = {
                    1,
                    settings.radius
                },
                angle = -math.pi / 6,
                color = Color.ui_grey_light(64, true)
            }
        }
    }, "minimap"),
}

local icon_templates = {
    assistance = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/assistance"),
    attention = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/attention"),
    enemy = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/enemy"),
    interactable = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/interactable"),
    objective = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/objective"),
    ping = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/ping"),
    player = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/player"),
    player_class = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/player_class"),
    teammate = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/teammate"),
    teammate_class = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/teammate_class"),
    threat = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/threat"),
    unknown = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/templates/unknown"),
}

return {
    widget_definitions = widget_definitions,
    scenegraph_definition = scenegraph_definition,
    icon_templates = icon_templates,
    settings = settings,
}
