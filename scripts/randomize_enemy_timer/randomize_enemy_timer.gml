function randomize_enemy_timer(_base_value, _variation)
{
    return max(
        1,
        round(
            random_range(
                _base_value * (1 - _variation),
                _base_value * (1 + _variation)
            )
        )
    );
}
