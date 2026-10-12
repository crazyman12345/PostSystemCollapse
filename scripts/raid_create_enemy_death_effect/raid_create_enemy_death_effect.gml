function raid_create_enemy_death_effect(_enemy)
{
    var _bbox_height = sprite_get_bbox_bottom(_enemy.enemy_sprite) - sprite_get_bbox_top(_enemy.enemy_sprite) + 1;
    var _draw_scale = 0.75 * (40 / _bbox_height) * _enemy.size_multiplier;

    var effect = {
        effect_x: _enemy.enemy_x,
        effect_y: _enemy.enemy_y,

        effect_sprite: _enemy.enemy_sprite,
        effect_frame: floor(_enemy.enemy_frame),

        effect_facing: _enemy.enemy_facing,
        effect_scale: _draw_scale,

        effect_angle: 0,
        effect_alpha: 1,

        effect_timer: 25
    };

    array_push(
        raid_enemy_death_effects,
        effect
    );
}
