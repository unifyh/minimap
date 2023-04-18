local mod = get_mod("minimap")

mod.settings = {}
mod.settings.icon_vis = {}

local hud_elements = {
    {
        filename = "minimap/scripts/mods/minimap/hud_element_minimap/hud_element_minimap",
        class_name = "HudElementMinimap",
    },
}

for _, hud_element in ipairs(hud_elements) do
    mod:add_require_path(hud_element.filename)
end

-- Taken from raindish
mod:hook("UIHud", "init", function(func, self, elements, visibility_groups, params)
    for _, hud_element in ipairs(hud_elements) do
        if not table.find_by_key(elements, "class_name", hud_element.class_name) then
            table.insert(elements, {
                class_name = hud_element.class_name,
                filename = hud_element.filename,
                use_hud_scale = true,
                visibility_groups = {
                    "alive",
                    "communication_wheel"
                },
            })
        end
    end

    return func(self, elements, visibility_groups, params)
end)

-- Taken from Fracticality
local function recreate_hud()
    local ui_manager = Managers.ui
    if ui_manager then
        local hud = ui_manager._hud
        if hud then
            local player_manager = Managers.player
            local player = player_manager:local_player(1)
            local peer_id = player:peer_id()
            local local_player_id = player:local_player_id()
            local elements = hud._element_definitions
            local visibility_groups = hud._visibility_groups

            hud:destroy()
            ui_manager:create_player_hud(peer_id, local_player_id, elements, visibility_groups)
        end
    end
end

local function collect_settings()
    mod.settings["display_class_icon"] = mod:get("display_class_icon")

    mod.settings.icon_vis["location_attention"] = mod:get("location_attention_vis")
    mod.settings.icon_vis["location_ping"] = mod:get("location_ping_vis")
    mod.settings.icon_vis["location_threat"] = mod:get("location_threat_vis")
    mod.settings.icon_vis["unit_threat"] = mod:get("unit_threat_vis")
    mod.settings.icon_vis["nameplate"] = mod:get("player_vis")
    mod.settings.icon_vis["nameplate_party"] = mod:get("player_vis")
    mod.settings.icon_vis["objective"] = mod:get("objective_vis")
    mod.settings.icon_vis["player_assistance"] = mod:get("assistance_vis")
    mod.settings.icon_vis["damage_indicator"] = mod:get("damaged_enemy_vis")
    mod.settings.icon_vis["interaction"] = mod:get("tagged_interaction_vis")
end

mod.on_all_mods_loaded = function()
    collect_settings()
    recreate_hud()
end

mod.on_setting_changed = function()
    collect_settings()
    recreate_hud()
end
