function icon_spin_frame(_sprite)
{
    var _frame_count = max(1, sprite_get_number(_sprite));
    return floor(current_time * icon_spin_speed / 1000) mod _frame_count;
}
