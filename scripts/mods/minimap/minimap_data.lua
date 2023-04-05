local mod = get_mod("minimap")

return {
    name = mod:localize("mod_name"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            {
                setting_id = "display_class_icon",
                type = "checkbox",
                default_value = true,
            },
        }
    }
}
