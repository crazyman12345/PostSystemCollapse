function raid_enemy_fire_bullet(_x, _y, _dir, _speed, _damage)
{
    array_push(
        raid_enemy_bullets,
        {
            bx: _x,
            by: _y,
            bdirection: _dir,
            bspeed: _speed,
            bdamage: _damage
        }
    );
}