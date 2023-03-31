local mod = get_mod("minimap")

local UIWidget = require("scripts/managers/ui/ui_widget")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")

local definitions = Mods.file.dofile("minimap/scripts/mods/minimap/hud_element_minimap/hud_element_minimap_definitions")

local HudElementMinimap = class("HudElementMinimap", "HudElementBase")

HudElementMinimap.init = function(self, parent, draw_layer, start_scale)
    HudElementMinimap.super.init(self, parent, draw_layer, start_scale, {
        widget_definitions = definitions.widget_definitions,
        scenegraph_definition = definitions.scenegraph_definition
    })

    self._settings = definitions.settings

    local templates = definitions.icon_templates
    self._icon_widgets_by_name = {}
    self._icon_update_functions_by_name = {}
    for name, template in pairs(templates) do
        self._icon_widgets_by_name[name] = UIWidget.init(name, template.definition)
        self._icon_update_functions_by_name[name] = template.update_function
    end

    self._registered_world_markers = false
end

HudElementMinimap._register_world_markers = function(self)
	self._registered_world_markers = true
	local cb = callback(self, "_cb_register_world_markers_list")

	Managers.event:trigger("request_world_markers_list", cb)
end

HudElementMinimap._cb_register_world_markers_list = function(self, world_markers)
	self._world_markers_list = world_markers
end

HudElementMinimap.update = function(self, dt, t, ui_renderer, render_settings, input_service)
    HudElementMinimap.super.update(self, dt, t, ui_renderer, render_settings, input_service)

    if not self._registered_world_markers then
		self:_register_world_markers()
	end
end

local markers_data = {}

HudElementMinimap._collect_markers = function(self)
    table.clear(markers_data)

    local world_markers_list = self._world_markers_list
    for i = 1, #world_markers_list do
        local marker = world_markers_list[i]
        local template = marker.template
        local template_name = template.name
        local azimuth, range = self:_get_marker_azimuth_range(marker)
        markers_data[#markers_data+1] = {
            azimuth = azimuth,
            range = range,
            name = template_name,
            marker = marker,
        }
    end

    return markers_data
end

HudElementMinimap._get_marker_azimuth_range = function (self, marker)
	local marker_position = marker.position and marker.position:unbox()

	if marker_position then
		local camera = self._parent:player_camera()

		if not camera then
			return 0, 0
		end

		local camera_position = ScriptCamera.position(camera)
		local camera_forward = Quaternion.forward(ScriptCamera.rotation(camera))
		local diff_vector = marker_position - camera_position
		diff_vector.z = 0
        local azimuth = Vector3.flat_angle(camera_forward, diff_vector)
        local range = Vector3.length(diff_vector)

		return azimuth, range
	end

	return 0, 0
end

local function get_hfov(vfov)
    local width = RESOLUTION_LOOKUP.width
	local height = RESOLUTION_LOOKUP.height
	local aspect_ratio = width / height
	local hfov = 2 * math.atan(math.tan(vfov / 2) * aspect_ratio)
	return hfov
end

local marker_name_to_icon = {
    location_attention = "attention",
    location_ping = "ping",
    location_threat = "threat",
    unit_threat = "threat",
    nameplate = "player", -- in hub
    nameplate_party = "teammate", -- in mission
    objective = "objective",
    player_assistance = "assistance",
    damage_indicator = "enemy",

    interaction = "none",
    health_bar = "none",
}

HudElementMinimap._draw_widgets = function(self, dt, t, input_service, ui_renderer)
    -- debug
    if mod.mn then
        mod.mn = false
        local world_markers_list = self._world_markers_list
        local str = ""

        for i = 1, #world_markers_list do
            local marker = world_markers_list[i]
            local template = marker.template
            local template_name = template.name
            if marker_name_to_icon[template_name] == "none" then
                goto continue
            end
            str = str .. template_name .. " "
            ::continue::
        end
        mod:echo(str)
    end

    local local_player = Managers.player:local_player(1)
    local vfov = 1
    if local_player then
        vfov = Managers.state.camera:fov(local_player.viewport_name) or 1
    end
    local hfov = get_hfov(vfov)
    local fov_indicator_style = self._widgets_by_name["fov_indicator"].style
    fov_indicator_style.fov_left.angle = hfov / 2
    fov_indicator_style.fov_right.angle = -hfov / 2

	HudElementMinimap.super._draw_widgets(self, dt, t, input_service, ui_renderer)

    local markers_data = self:_collect_markers()
    for _, marker_datum in ipairs(markers_data) do
        local icon_name = marker_name_to_icon[marker_datum.name] or "unknown"

        if icon_name == "none" then
            goto continue
        end

        local widget = self._icon_widgets_by_name[icon_name]

        local radius = marker_datum.range / self._settings.max_range * self._settings.radius
        if radius > self._settings.radius then
            radius = self._settings.out_of_range_radius
        end
        local x = radius * -math.sin(marker_datum.azimuth)
        local y = radius * -math.cos(marker_datum.azimuth)

        local update_function = self._icon_update_functions_by_name[icon_name]
        update_function(widget, marker_datum.marker, x, y)

        UIWidget.draw(widget, ui_renderer)
        ::continue::
    end

end

return HudElementMinimap
