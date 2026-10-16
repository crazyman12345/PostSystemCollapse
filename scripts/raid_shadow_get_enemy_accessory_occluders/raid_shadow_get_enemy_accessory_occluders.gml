function raid_shadow_get_enemy_accessory_occluders(_enemy)
{
    var _accessories = [];
    if (_enemy.weapon == -1 || is_undefined(_enemy.weapon) || !is_struct(_enemy.weapon)) return _accessories;
    var _weapon = _enemy.weapon;
    if (_weapon.weapon_sprite < 0 || !sprite_exists(_weapon.weapon_sprite)) return _accessories;

    var _scale = variable_struct_exists(_enemy, "size_multiplier") ? _enemy.size_multiplier : 1;
    var _dir = _enemy.enemy_gun_angle;
    var _flip = (_dir > 90 && _dir < 270) ? -1 : 1;
    var _weapon_offset_y = variable_struct_exists(_weapon, "weapon_offset_y") ? _weapon.weapon_offset_y * _scale * _flip : 0;
    var _offset = _enemy.enemy_gun_recoil + (_weapon.weapon_offset_x * _scale);
    var _gun_x = _enemy.enemy_x + lengthdir_x(_offset, _dir) + lengthdir_x(_weapon_offset_y, _dir + 90);
    var _gun_y = _enemy.enemy_y - (18 * _scale) + lengthdir_y(_offset, _dir);
    var _visible_width = max(1, sprite_get_bbox_right(_weapon.weapon_sprite) - sprite_get_bbox_left(_weapon.weapon_sprite) + 1);
    var _weapon_scale = (_weapon.weapon_draw_width / _visible_width) * 0.75 * _scale;
    array_push(_accessories, raid_shadow_character_accessory(
        _weapon.weapon_sprite, _gun_x, _gun_y, _weapon_scale, _weapon_scale * _flip, _dir
    ));

    if (_enemy.enemy_hand_sprite != -1 && sprite_exists(_enemy.enemy_hand_sprite))
    {
        var _hand1_x = _gun_x + lengthdir_x(_weapon.hand1_x * _scale, _dir) + lengthdir_x(_weapon.hand1_y * _scale * _flip, _dir + 90);
        var _hand1_y = _gun_y + lengthdir_y(_weapon.hand1_x * _scale, _dir) + lengthdir_y(_weapon.hand1_y * _scale * _flip, _dir + 90);
        array_push(_accessories, raid_shadow_character_accessory(_enemy.enemy_hand_sprite, _hand1_x, _hand1_y, _scale, _scale * _flip, _dir));

        if (_weapon.has_second_hand)
        {
            var _hand2_x = _gun_x + lengthdir_x(_weapon.hand2_x * _scale, _dir) + lengthdir_x(_weapon.hand2_y * _scale * _flip, _dir + 90);
            var _hand2_y = _gun_y + lengthdir_y(_weapon.hand2_x * _scale, _dir) + lengthdir_y(_weapon.hand2_y * _scale * _flip, _dir + 90);
            array_push(_accessories, raid_shadow_character_accessory(_enemy.enemy_hand_sprite, _hand2_x, _hand2_y, _scale, _scale * _flip, _dir));
        }
    }
    return _accessories;
}
