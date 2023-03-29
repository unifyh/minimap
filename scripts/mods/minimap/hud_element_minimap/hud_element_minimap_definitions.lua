local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")

local minimap_settings = {
    radius = 125,
    out_of_range_radius = 135,
	size = { 280, 280 },
	icon_size = { 20, 20 },
	max_range = 15.0,
}

local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	minimap = {
		parent = "screen",
		vertical_alignment = "top",
		horizontal_alignment = "right",
		size = minimap_settings.size,
		position = { -50, 50, 10 },
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
					minimap_settings.radius * 2,
					minimap_settings.radius * 2
				},
                color = Color.ui_grey_medium(127, true)
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
                offset = { 0, -minimap_settings.radius / 2, -1 },
                size = { 2, minimap_settings.radius },
                pivot = {
					1,
                    minimap_settings.radius
				},
				angle = math.pi / 6,
                color = Color.ui_grey_light(127, true)
            }
		},
		{
			value = "content/ui/materials/dividers/divider_line_01",
			pass_type = "rotated_texture",
			style_id = "fov_right",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = { 0, -minimap_settings.radius / 2, -1 },
				size = { 2, minimap_settings.radius },
				pivot = {
					1,
					minimap_settings.radius
				},
				angle = -math.pi / 6,
				color = Color.ui_grey_light(127, true)
			}
		}
	}, "minimap"),
}

local icon_definitions = {
	unknown = UIWidget.create_definition({
        {
            pass_type = "texture",
			value = "content/ui/materials/backgrounds/default_square",
            style_id = "icon",
            style = {
                vertical_alignment = "center",
				horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = minimap_settings.icon_size,
                color = UIHudSettings.color_tint_main_1
            }
        },
    }, "minimap"),
	attention = UIWidget.create_definition({
        {
            pass_type = "texture_uv",
			value = "content/ui/materials/hud/interactions/icons/attention",
            style_id = "icon",
            style = {
				uvs = {
					{ 0.1, 0.1 },
					{ 0.9, 0.9 }
				},
                vertical_alignment = "center",
				horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = minimap_settings.icon_size,
                color = Color.ui_hud_green_super_light(255, true)
            }
        },
    }, "minimap"),
	ping = UIWidget.create_definition({
        {
            pass_type = "texture_uv",
			value = "content/ui/materials/hud/interactions/icons/location",
            style_id = "icon",
            style = {
				uvs = {
					{ 0.1, 0.1 },
					{ 0.9, 0.9 }
				},
                vertical_alignment = "center",
				horizontal_alignment = "center",
                offset = { 0, 0, 0 },
                size = minimap_settings.icon_size,
                color = Color.ui_hud_green_super_light(255, true)
            }
        },
    }, "minimap"),
	threat = UIWidget.create_definition({
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
                size = minimap_settings.icon_size,
                color = Color.ui_hud_red_light(255, true)
            }
        },
    }, "minimap"),
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	icon_definitions = icon_definitions,
	settings = minimap_settings,
}
