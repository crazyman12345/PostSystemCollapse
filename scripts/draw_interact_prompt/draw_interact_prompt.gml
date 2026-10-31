function draw_interact_prompt(_world_x, _world_y)
{
    var _box_w = 18;
    var _box_h = 18;

    var _x1 = _world_x - (_box_w * 0.5);
    var _y1 = _world_y - (_box_h * 0.5);
    var _x2 = _world_x + (_box_w * 0.5);
    var _y2 = _world_y + (_box_h * 0.5);

    draw_set_color(c_black);
    draw_rectangle(
        _x1,
        _y1,
        _x2,
        _y2,
        false
    );

    draw_set_color(global.ui_interactive_color);
    draw_rectangle(
        _x1,
        _y1,
        _x2,
        _y2,
        true
    );

    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_text_transformed(
        _world_x,
        _world_y,
        "E",
        0.3,
        0.3,
        0
    );

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
