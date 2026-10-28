function graphics_settings_defaults()
{
    return {
        dynamic_lighting: true,
        muzzle_flash_lighting: true,
        ambient_darkness: true,
        colored_lighting: true,
        light_falloff: true,
        environment_shadows: true,
        character_shadows: true,
        contact_shadows: true,
        smoke_effects: true,
        blood_effects: true,
        death_gibs: true,
        projectile_glow: true,
        projectile_lighting: true,
        bloom: true,
        player_minimum_brightness: 0.90,
        enemy_minimum_brightness: 0.80,
        attack_ring_minimum_brightness: 1.00,
        blood_minimum_brightness: 0
    };
}

function graphics_settings_load()
{
    global.graphics_settings = graphics_settings_defaults();
    if (file_exists("settings.ini"))
    {
        try
        {
            ini_open("settings.ini");
            var _settings = global.graphics_settings;
            _settings.dynamic_lighting = ini_read_real("Graphics", "dynamic_lighting", 1) > 0;
            _settings.muzzle_flash_lighting = ini_read_real("Graphics", "muzzle_flash_lighting", 1) > 0;
            _settings.ambient_darkness = ini_read_real("Graphics", "ambient_darkness", 1) > 0;
            _settings.colored_lighting = ini_read_real("Graphics", "colored_lighting", 1) > 0;
            _settings.light_falloff = ini_read_real("Graphics", "light_falloff", 1) > 0;
            _settings.environment_shadows = ini_read_real("Graphics", "environment_shadows", 1) > 0;
            _settings.character_shadows = ini_read_real("Graphics", "character_shadows", 1) > 0;
            _settings.contact_shadows = ini_read_real("Graphics", "contact_shadows", 1) > 0;
            _settings.smoke_effects = ini_read_real("Graphics", "smoke_effects", 1) > 0;
            _settings.blood_effects = ini_read_real("Graphics", "blood_effects", 1) > 0;
            _settings.death_gibs = ini_read_real("Graphics", "death_gibs", 1) > 0;
            _settings.projectile_glow = ini_read_real("Graphics", "projectile_glow", 1) > 0;
            _settings.projectile_lighting = ini_read_real("Graphics", "projectile_lighting", 1) > 0;
            _settings.bloom = ini_read_real("Graphics", "bloom", 1) > 0;
            _settings.player_minimum_brightness = clamp(ini_read_real("Graphics", "player_minimum_brightness", 0.90), 0, 1);
            _settings.enemy_minimum_brightness = clamp(ini_read_real("Graphics", "enemy_minimum_brightness", 0.80), 0, 1);
            _settings.attack_ring_minimum_brightness = clamp(ini_read_real("Graphics", "attack_ring_minimum_brightness", 1.00), 0, 1);
            _settings.blood_minimum_brightness = clamp(ini_read_real("Graphics", "blood_minimum_brightness", 0), 0, 1);
            ini_close();
        }
        catch (_error)
        {
            global.graphics_settings = graphics_settings_defaults();
        }
    }

    graphics_settings_apply();
}

function graphics_settings_save()
{
    var _settings = global.graphics_settings;
    ini_open("settings.ini");
    ini_write_real("Graphics", "dynamic_lighting", _settings.dynamic_lighting);
    ini_write_real("Graphics", "muzzle_flash_lighting", _settings.muzzle_flash_lighting);
    ini_write_real("Graphics", "ambient_darkness", _settings.ambient_darkness);
    ini_write_real("Graphics", "colored_lighting", _settings.colored_lighting);
    ini_write_real("Graphics", "light_falloff", _settings.light_falloff);
    ini_write_real("Graphics", "environment_shadows", _settings.environment_shadows);
    ini_write_real("Graphics", "character_shadows", _settings.character_shadows);
    ini_write_real("Graphics", "contact_shadows", _settings.contact_shadows);
    ini_write_real("Graphics", "smoke_effects", _settings.smoke_effects);
    ini_write_real("Graphics", "blood_effects", _settings.blood_effects);
    ini_write_real("Graphics", "death_gibs", _settings.death_gibs);
    ini_write_real("Graphics", "projectile_glow", _settings.projectile_glow);
    ini_write_real("Graphics", "projectile_lighting", _settings.projectile_lighting);
    ini_write_real("Graphics", "bloom", _settings.bloom);
    ini_write_real("Graphics", "player_minimum_brightness", _settings.player_minimum_brightness);
    ini_write_real("Graphics", "enemy_minimum_brightness", _settings.enemy_minimum_brightness);
    ini_write_real("Graphics", "attack_ring_minimum_brightness", _settings.attack_ring_minimum_brightness);
    ini_write_real("Graphics", "blood_minimum_brightness", _settings.blood_minimum_brightness);
    ini_close();
}

function graphics_settings_set(_key, _enabled)
{
    if (!variable_struct_exists(global.graphics_settings, _key)) return;
    variable_struct_set(global.graphics_settings, _key, _enabled);
    graphics_settings_apply();
    graphics_settings_save();
}

function graphics_settings_toggle(_key)
{
    graphics_settings_set(_key, !variable_struct_get(global.graphics_settings, _key));
}

function graphics_settings_restore_defaults()
{
    global.graphics_settings = graphics_settings_defaults();
    graphics_settings_apply();
    graphics_settings_save();
}

function graphics_settings_apply()
{
    var _settings = global.graphics_settings;
    raid_bloom_enabled = _settings.bloom;
    raid_character_shadows_enabled = _settings.contact_shadows;

    if (!_settings.smoke_effects)
    {
        part_particles_clear(smoke_particle_system);
        smoke_particle_update_accumulator = 0;
        smoke_particle_count = 0;
    }
    if (!_settings.blood_effects)
    {
        blood_surface_destroy();
        raid_blood_spray_particles = [];
    }
    if (!_settings.death_gibs) raid_enemy_death_effects = [];
}

function graphics_settings_release_surface(_surface)
{
    if (surface_exists(_surface)) surface_free(_surface);
    return -1;
}
