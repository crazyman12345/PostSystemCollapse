function draw_raid_shadowed_radial_light(_light, _occluders, _camera_x, _camera_y, _strength, _color, _debug_visibility = false, _rgb_strength = undefined)
{
    var _falloff_rotation = variable_struct_exists(_light, "falloff_rotation") ? _light.falloff_rotation : 0;
    var _falloff_x_scale = variable_struct_exists(_light, "falloff_x_scale") ? _light.falloff_x_scale : 1;
    var _falloff_y_scale = variable_struct_exists(_light, "falloff_y_scale") ? _light.falloff_y_scale : 1;
    var _falloff_offset = variable_struct_exists(_light, "falloff_offset") ? _light.falloff_offset : 0;
    var _inward_reach_multiplier = variable_struct_exists(_light, "inward_reach_multiplier") ? _light.inward_reach_multiplier : 1;
    var _inward_center_offset = _falloff_offset + _falloff_x_scale * (_inward_reach_multiplier - 1);
    var _draw_x = _light.x + lengthdir_x(_light.radius * _inward_center_offset, _falloff_rotation) - _camera_x;
    var _draw_y = _light.y + lengthdir_y(_light.radius * _inward_center_offset, _falloff_rotation) - _camera_y;
    _falloff_x_scale *= _inward_reach_multiplier;

    if (!raid_radial_light_is_visible(_draw_x, _draw_y, _light.radius, _falloff_x_scale, _falloff_y_scale)) return;

    var _rectangle_positions = array_create(32, 0);
    var _rectangle_half_sizes = array_create(32, 0);
    var _rectangle_heights = array_create(16, 0);
    var _rectangle_rotations = array_create(16, 0);
    var _sprite_ground_positions = array_create(48, 0);
    var _sprite_axes = array_create(48, 0);
    var _sprite_sizes = array_create(48, 1);
    var _sprite_source_positions = array_create(48, 0);
    var _sprite_source_sizes = array_create(48, 1);
    var _sprite_source_exclusions = array_create(24, 0);
    var _sprite_uvs = array_create(96, 0);
    var _sprite_flips = array_create(24, 0);
    var _sprite_flip_ys = array_create(24, 0);
    var _sprite_source_axes = array_create(48, 0);
    var _sprite_shared_anchor_projections = array_create(24, 0);
    var _sprite_projection_height_scales = array_create(24, 1);
    var _sprite_texture_indices = array_create(24, 0);
    var _sprite_textures = [];
    var _rectangle_count = 0;
    var _sprite_count = 0;
    var _cull_occluders = variable_struct_exists(_light, "muzzle_flash") && _light.muzzle_flash;

    for (var _occluder_index = 0; _occluder_index < array_length(_occluders); _occluder_index++)
    {
        var _occluder = _occluders[_occluder_index];
        if (!_occluder.enabled) continue;

        if (_cull_occluders)
        {
            var _occluder_reach = _occluder.geometry.type == "rectangle"
                ? point_distance(0, 0, _occluder.geometry.width * 0.5, _occluder.geometry.depth * 0.5)
                : _occluder.geometry.width * 0.5;
            if (point_distance(_light.x, _light.y, _occluder.position.x, _occluder.position.y) > _light.radius + _occluder_reach) continue;
        }

        if (_occluder.geometry.type == "rectangle" && _rectangle_count < 16)
        {
            var _rectangle_offset = _rectangle_count * 2;
            _rectangle_positions[_rectangle_offset] = _occluder.position.x - _camera_x;
            _rectangle_positions[_rectangle_offset + 1] = _occluder.position.y - _camera_y;
            _rectangle_half_sizes[_rectangle_offset] = _occluder.geometry.width * 0.5;
            _rectangle_half_sizes[_rectangle_offset + 1] = _occluder.geometry.depth * 0.5;
            _rectangle_heights[_rectangle_count] = _occluder.height;
            _rectangle_rotations[_rectangle_count] = degtorad(_occluder.rotation);
            _rectangle_count++;
        }
        else if (_occluder.geometry.type == "sprite" && _sprite_count < 24)
        {
            var _silhouette = _occluder.geometry.silhouette;
            var _texture_slot = -1;
            for (var _existing_texture_index = 0; _existing_texture_index < array_length(_sprite_textures); _existing_texture_index++)
            {
                if (_sprite_textures[_existing_texture_index] == _silhouette.texture)
                {
                    _texture_slot = _existing_texture_index;
                    break;
                }
            }
            if (_texture_slot < 0)
            {
                if (array_length(_sprite_textures) >= 8) continue;
                _texture_slot = array_length(_sprite_textures);
                array_push(_sprite_textures, _silhouette.texture);
            }

            var _sprite_offset = _sprite_count * 2;
            var _uv_offset = _sprite_count * 4;
            _sprite_ground_positions[_sprite_offset] = _occluder.position.x - _camera_x;
            _sprite_ground_positions[_sprite_offset + 1] = _occluder.position.y - _camera_y;
            var _projection_rotation = variable_struct_exists(_occluder, "projection_rotation") ? _occluder.projection_rotation : _occluder.rotation;
            _sprite_axes[_sprite_offset] = lengthdir_x(1, _projection_rotation);
            _sprite_axes[_sprite_offset + 1] = lengthdir_y(1, _projection_rotation);
            _sprite_sizes[_sprite_offset] = _occluder.geometry.width;
            _sprite_sizes[_sprite_offset + 1] = _occluder.height;
            _sprite_source_positions[_sprite_offset] = _occluder.source_position.x - _camera_x;
            _sprite_source_positions[_sprite_offset + 1] = _occluder.source_position.y - _camera_y;
            _sprite_source_sizes[_sprite_offset] = _occluder.source_size.width;
            _sprite_source_sizes[_sprite_offset + 1] = _occluder.source_size.height;
            _sprite_source_exclusions[_sprite_count] = _occluder.exclude_source_from_shadow;
            _sprite_uvs[_uv_offset] = _silhouette.uv_left;
            _sprite_uvs[_uv_offset + 1] = _silhouette.uv_top;
            _sprite_uvs[_uv_offset + 2] = _silhouette.uv_right;
            _sprite_uvs[_uv_offset + 3] = _silhouette.uv_bottom;
            _sprite_flips[_sprite_count] = _occluder.flip_x;
            _sprite_flip_ys[_sprite_count] = _occluder.flip_y;
            _sprite_source_axes[_sprite_offset] = lengthdir_x(1, _occluder.rotation);
            _sprite_source_axes[_sprite_offset + 1] = lengthdir_y(1, _occluder.rotation);
            _sprite_shared_anchor_projections[_sprite_count] = variable_struct_exists(_occluder, "shared_anchor_projection") && _occluder.shared_anchor_projection;
            _sprite_projection_height_scales[_sprite_count] = variable_struct_exists(_occluder, "projection_height_scale") ? _occluder.projection_height_scale : 1;
            _sprite_texture_indices[_sprite_count] = _texture_slot;
            _sprite_count++;
        }
    }

    if (_rectangle_count <= 0 && _sprite_count <= 0)
    {
        draw_raid_radial_light(_draw_x, _draw_y, _light.radius, _strength, _color, _falloff_rotation, _falloff_x_scale, _falloff_y_scale,
            32, variable_struct_exists(_light, "soft_falloff") && _light.soft_falloff, _rgb_strength);
        return;
    }

    shader_set(shd_raid_shadow_visibility);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_light_position"), _light.x - _camera_x, _light.y - _camera_y);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_light_height"), raid_light_get_shadow_height(_light));
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_count"), _rectangle_count);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_position"), _rectangle_positions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_half_size"), _rectangle_half_sizes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_height"), _rectangle_heights);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_rectangle_rotation"), _rectangle_rotations);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_count"), _sprite_count);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_ground_position"), _sprite_ground_positions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_axis"), _sprite_axes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_size"), _sprite_sizes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_source_position"), _sprite_source_positions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_source_size"), _sprite_source_sizes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_exclude_source"), _sprite_source_exclusions);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_uv"), _sprite_uvs);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_flip"), _sprite_flips);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_flip_y"), _sprite_flip_ys);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_source_axis"), _sprite_source_axes);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_shared_anchor_projection"), _sprite_shared_anchor_projections);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_projection_height_scale"), _sprite_projection_height_scales);
    shader_set_uniform_f_array(shader_get_uniform(shd_raid_shadow_visibility, "u_sprite_texture_index"), _sprite_texture_indices);
    for (var _texture_index = 0; _texture_index < array_length(_sprite_textures); _texture_index++)
    {
        var _sampler = shader_get_sampler_index(shd_raid_shadow_visibility, "u_sprite_texture_" + string(_texture_index));
        texture_set_stage(_sampler, _sprite_textures[_texture_index]);
    }
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_debug_visibility"), _debug_visibility);
    var _rgb_scale = is_undefined(_rgb_strength) ? 1
        : clamp(_rgb_strength, 0, 1) / max(clamp(_strength, 0, 1), 0.001);
    shader_set_uniform_f(shader_get_uniform(shd_raid_shadow_visibility, "u_rgb_scale"), _rgb_scale);
    draw_raid_radial_light(_draw_x, _draw_y, _light.radius, _strength, _color, _falloff_rotation, _falloff_x_scale, _falloff_y_scale,
        32, variable_struct_exists(_light, "soft_falloff") && _light.soft_falloff);
    shader_reset();
}
