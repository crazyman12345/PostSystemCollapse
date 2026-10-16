function draw_inventory_grid_item(_stored_item, _definition, _left, _top, _grid_width, _grid_height, _cell_size, _selected, _text_color = c_black)
{
    var item_right = _left + (_grid_width * _cell_size);
    var item_bottom = _top + (_grid_height * _cell_size);

    draw_set_color(_selected ? c_lime : c_gray);
    draw_rectangle(_left + 4, _top + 4, item_right - 4, item_bottom - 4, false);

    var grid_sprite = -1;
    if (variable_struct_exists(_definition, "icon_sprite")) grid_sprite = _definition.icon_sprite;
    if ((grid_sprite == -1 || !sprite_exists(grid_sprite)) && variable_struct_exists(_definition, "weapon_sprite")) grid_sprite = _definition.weapon_sprite;
    if ((grid_sprite == -1 || !sprite_exists(grid_sprite)) && variable_struct_exists(_definition, "sprite_idle")) grid_sprite = _definition.sprite_idle;

    if (grid_sprite == -1 || !sprite_exists(grid_sprite)) grid_sprite = spr_error;
    var has_sprite = grid_sprite != -1 && sprite_exists(grid_sprite);

    if (has_sprite)
    {
        var padding = 8;
        var available_width = max(1, (item_right - _left) - (padding * 2));
        var available_height = max(1, (item_bottom - _top) - (padding * 2));
        var _bbox_left = sprite_get_bbox_left(grid_sprite);
        var _bbox_top = sprite_get_bbox_top(grid_sprite);
        var _bbox_right = sprite_get_bbox_right(grid_sprite);
        var _bbox_bottom = sprite_get_bbox_bottom(grid_sprite);
        var _bbox_width = _bbox_right - _bbox_left + 1;
        var _bbox_height = _bbox_bottom - _bbox_top + 1;
        var sprite_rotation = _stored_item.rotation == 90 && _definition.grid_width != _definition.grid_height ? 90 : 0;
        var visible_center_x = ((_bbox_left + _bbox_right) * 0.5) - sprite_get_xoffset(grid_sprite);
        var visible_center_y = ((_bbox_top + _bbox_bottom) * 0.5) - sprite_get_yoffset(grid_sprite);
        var fit_width = sprite_rotation == 90 ? _bbox_height : _bbox_width;
        var fit_height = sprite_rotation == 90 ? _bbox_width : _bbox_height;
        var sprite_scale = min(available_width / fit_width, available_height / fit_height);
        var center_x = ( _left + item_right ) * 0.5;
        var center_y = ( _top + item_bottom ) * 0.5;
        var offset_distance = point_distance(0, 0, visible_center_x, visible_center_y);
        var offset_direction = point_direction(0, 0, visible_center_x, visible_center_y);
        var rotated_offset_x = lengthdir_x(offset_distance * sprite_scale, offset_direction + sprite_rotation);
        var rotated_offset_y = lengthdir_y(offset_distance * sprite_scale, offset_direction + sprite_rotation);

        draw_sprite_ext(grid_sprite, 0, center_x - rotated_offset_x, center_y - rotated_offset_y, sprite_scale, sprite_scale, sprite_rotation, c_white, 1);
    }
    else
    {
        draw_set_color(_text_color);

        draw_text_ext(_left + 10, _top + 10, _definition.name, 20, (_grid_width * _cell_size) - 20);
    }

    if (_stored_item.quantity > 1)
    {
        var previous_halign = draw_get_halign();
        draw_set_color(c_black);
        draw_set_halign(fa_right);
        draw_text(item_right - 8, _top + 8, "x" + format_compact_number(_stored_item.quantity));
        draw_set_halign(previous_halign);
    }
}