return {
    run = function()
        fassert(rawget(_G, "new_mod"), "`minimap` encountered an error loading the Darktide Mod Framework.")

        new_mod("minimap", {
            mod_script       = "minimap/scripts/mods/minimap/minimap",
            mod_data         = "minimap/scripts/mods/minimap/minimap_data",
            mod_localization = "minimap/scripts/mods/minimap/minimap_localization",
        })
    end,
    packages = {},
}
