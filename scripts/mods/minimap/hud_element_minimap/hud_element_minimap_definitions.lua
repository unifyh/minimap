local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UISettings = require("scripts/settings/ui/ui_settings")
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
		vertical_alignment = "center",
		horizontal_alignment = "left",
		size = minimap_settings.size,
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
					minimap_settings.radius * 2,
					minimap_settings.radius * 2
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
                offset = { 0, -minimap_settings.radius / 2, -1 },
                size = { 2, minimap_settings.radius },
                pivot = {
					1,
                    minimap_settings.radius
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
				offset = { 0, -minimap_settings.radius / 2, -1 },
				size = { 2, minimap_settings.radius },
				pivot = {
					1,
					minimap_settings.radius
				},
				angle = -math.pi / 6,
				color = Color.ui_grey_light(64, true)
			}
		}
	}, "minimap"),
}

local function default_update_function(widget, marker, x, y)
	local icon = widget.style.icon
	icon.offset[1] = x
	icon.offset[2] = y
end

local demolition_center_distance = 6
local demolition_marker_size = {
	12,
	6
}
local demolition_marker_style = {
	vertical_alignment = "center",
	horizontal_alignment = "center",
	angle = 0,
	offset = {
		demolition_center_distance,
		0,
		1
	},
	default_offset = {
		demolition_center_distance,
		0,
		1
	},
	size = demolition_marker_size,
	pivot = {
		demolition_marker_size[1] * 0.5 - demolition_center_distance,
		demolition_marker_size[2] * 0.5
	},
	color = Color.ui_terminal(255, true)
}

local icon_templates = {
	unknown = {
		definition = UIWidget.create_definition({
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
		update_function = default_update_function
	},

	attention = {
		definition = UIWidget.create_definition({
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
		update_function = default_update_function
	},

	ping = {
		definition = UIWidget.create_definition({
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
		update_function = default_update_function
	},

	threat = {
		definition = UIWidget.create_definition({
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
					size = minimap_settings.icon_size,
					color = { 255, 236, 165, 50 }
				}
			},
		}, "minimap"),
		update_function = function(widget, marker, x, y)
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
	},

	player = {
		definition = UIWidget.create_definition({
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
					drop_shadow = false,
					font_type = "proxima_nova_bold",
					font_size = 20,
					default_font_size = 20,
					text_color = Color.ui_hud_green_light(255, true),
					default_text_color = Color.ui_hud_green_light(255, true),
					size = minimap_settings.icon_size
				}
			},
		}, "minimap"),
		update_function = default_update_function
	},

	teammate = {
		definition = UIWidget.create_definition({
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
					drop_shadow = false,
					font_type = "proxima_nova_bold",
					font_size = 20,
					default_font_size = 20,
					text_color = Color.ui_hud_green_light(255, true),
					default_text_color = Color.black(255, true),
					size = minimap_settings.icon_size
				}
			},
		}, "minimap"),
		update_function = function(widget, marker, x, y)
			default_update_function(widget, marker, x, y)

			local icon = widget.style.icon
			local data = marker.data
			local player_slot = data:slot()
			icon.text_color = UISettings.player_slot_colors[player_slot] or icon.default_text_color
		end
	},

	objective = {
		definition = UIWidget.create_definition({
			{
				pass_type = "texture_uv",
				value = "content/ui/materials/hud/interactions/icons/objective_main",
				style_id = "main",
				style = {
					uvs = {
						{ 0.1, 0.1 },
						{ 0.9, 0.9 }
					},
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = { 0, 0, 1 },
					size = minimap_settings.icon_size,
					color = UIHudSettings.color_tint_main_1
				}
			},
			{
				pass_type = "texture_uv",
				value = "content/ui/materials/hud/interactions/frames/point_of_interest_top",
				style_id = "main2",
				style = {
					uvs = {
						{ 0.2, 0.2 },
						{ 0.8, 0.8 }
					},
					vertical_alignment = "center",
					horizontal_alignment = "center",
					offset = { 0, 0, 0 },
					size = minimap_settings.icon_size,
					color = UIHudSettings.color_tint_main_1
				}
			},
			{
				pass_type = "rotated_texture",
				style_id = "demo1",
				value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer",
				style = demolition_marker_style,
			},
			{
				pass_type = "rotated_texture",
				style_id = "demo2",
				value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer",
				style = demolition_marker_style,
			},
			{
				pass_type = "rotated_texture",
				style_id = "demo3",
				value = "content/ui/materials/hud/icons/objective_demolition/demolition_indicator_pointer",
				style = demolition_marker_style,
			},
		}, "minimap"),
		update_function = function(widget, marker, x, y)
			local main = widget.style.main
			local main2 = widget.style.main2
			main.offset[1] = x
			main.offset[2] = y
			main2.offset[1] = x
			main2.offset[2] = y

			local demo1 = widget.style.demo1
			local demo2 = widget.style.demo2
			local demo3 = widget.style.demo3
			local time_since_launch = Application.time_since_launch()
			local angle = time_since_launch % (math.pi * 2)
			demo1.angle = angle
			demo2.angle = angle + math.pi * 2 / 3
			demo3.angle = angle + math.pi * 4 / 3
			demo1.offset[1] = demo1.default_offset[1] + x
			demo1.offset[2] = demo1.default_offset[2] + y
			demo2.offset[1] = demo2.default_offset[1] + x
			demo2.offset[2] = demo2.default_offset[2] + y
			demo3.offset[1] = demo3.default_offset[1] + x
			demo3.offset[2] = demo3.default_offset[2] + y

			local ui_target_type = marker.data.ui_target_type or "default"
			if ui_target_type == "demolition" or ui_target_type == "corruptor" then
				main.visible = false
				main2.visible = false
				demo1.visible = true
				demo2.visible = true
				demo3.visible = true
			else
				main.visible = true
				main2.visible = true
				demo1.visible = false
				demo2.visible = false
				demo3.visible = false
			end
		end
	},

	assistance = {
		definition = UIWidget.create_definition({
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
						minimap_settings.icon_size[1] / 4,
						minimap_settings.icon_size[2] / 2,
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
						minimap_settings.icon_size[1],
						minimap_settings.icon_size[2] * 0.9,
					},
					color = { 255, 236, 50, 50 }
				}
			},
		}, "minimap"),
		update_function = function(widget, marker, x, y)
			local icon = widget.style.icon
			local frame = widget.style.frame
			icon.offset[1] = x + icon.default_offset[1]
			icon.offset[2] = y + icon.default_offset[2]
			frame.offset[1] = x
			frame.offset[2] = y
		end
	}
}

return {
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	icon_templates = icon_templates,
	settings = minimap_settings,
}
