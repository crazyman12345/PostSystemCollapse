function step_raid_wall_lights(_time_scale = frame_scale)
{
    for (var _light_index = 0; _light_index < array_length(raid_wall_lights); _light_index++)
    {
        var _light = raid_wall_lights[_light_index];

        switch (_light.mode)
        {
            case RaidWallLightMode.STABLE:
                _light.flicker_phase += 0.8 * _time_scale;
                _light.brightness = 0.975 + 0.025 * dsin(_light.flicker_phase);
                break;

            case RaidWallLightMode.FAULTY:
                _light.flicker_phase += 0.8 * _time_scale;

                if (_light.flicker_active)
                {
                    _light.flicker_active_timer -= _time_scale;
                    _light.flicker_change_timer -= _time_scale;

                    if (_light.flicker_change_timer <= 0)
                    {
                        _light.brightness = random_range(0.4, 1);
                        _light.flicker_change_timer += random_range(1, 5);
                    }

                    if (_light.flicker_active_timer <= 0)
                    {
                        _light.flicker_active = false;
                        _light.flicker_event_timer = random_range(120, 360);
                    }
                }
                else
                {
                    _light.brightness = 0.975 + 0.025 * dsin(_light.flicker_phase);
                    _light.flicker_event_timer -= _time_scale;

                    if (_light.flicker_event_timer <= 0)
                    {
                        _light.flicker_active = true;
                        _light.flicker_active_timer = random_range(8, 24);
                        _light.flicker_change_timer = 0;
                    }
                }
                break;

            case RaidWallLightMode.DYING:
                if (_light.flicker_active)
                {
                    _light.flicker_active_timer -= _time_scale;
                    if (_light.flicker_active_timer <= 0)
                    {
                        _light.flicker_active = false;
                        _light.brightness = 0;
                        _light.flicker_event_timer = random_range(60, 300);
                    }
                }
                else
                {
                    _light.flicker_event_timer -= _time_scale;
                    if (_light.flicker_event_timer <= 0)
                    {
                        _light.flicker_active = true;
                        _light.brightness = random_range(0.4, 1);
                        _light.flicker_active_timer = random_range(2, 30);
                    }
                }
                break;
        }

        _light.enabled = _light.base_enabled && _light.brightness > 0;
        _light.intensity = _light.base_intensity * _light.brightness;
        _light.core_intensity = _light.base_core_intensity * _light.brightness;
    }
}
