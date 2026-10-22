function tutorial_callout_init()
{
    global.tutorial_callout_state = {
        active: false,
        message: "",
        target_x: 0,
        target_y: 0,
        box_x: 0,
        box_y: 0,
        box_width: 0,
        box_height: 0
    };
}

function tutorial_callout_show(_message, _target_x, _target_y, _box_x, _box_y, _box_width = 620, _box_height = 140)
{
    if (!variable_global_exists("tutorial_callout_state")) tutorial_callout_init();
    global.tutorial_callout_state.active = true;
    global.tutorial_callout_state.message = _message;
    global.tutorial_callout_state.target_x = _target_x;
    global.tutorial_callout_state.target_y = _target_y;
    global.tutorial_callout_state.box_x = _box_x;
    global.tutorial_callout_state.box_y = _box_y;
    global.tutorial_callout_state.box_width = _box_width;
    global.tutorial_callout_state.box_height = _box_height;
}

function tutorial_callout_hide()
{
    if (!variable_global_exists("tutorial_callout_state")) tutorial_callout_init();
    global.tutorial_callout_state.active = false;
}

function tutorial_callout_draw()
{
    if (!variable_global_exists("tutorial_callout_state")) tutorial_callout_init();
    var _callout = global.tutorial_callout_state;
    if (!_callout.active) return;

    var _target_x = _callout.target_x;
    var _target_y = _callout.target_y;
    var _box_left = _callout.box_x;
    var _box_top = _callout.box_y;
    var _box_right = _box_left + _callout.box_width;
    var _box_bottom = _box_top + _callout.box_height;
    var _box_mid_y = (_box_top + _box_bottom) * 0.5;
    var _target_is_left = _target_x < (_box_left + _box_right) * 0.5;
    var _box_edge_x = _target_is_left ? _box_left : _box_right;
    var _elbow_x = lerp(_target_x, _box_edge_x, 0.55);
    var _circle_radius = 10;
    var _line_direction = point_direction(_target_x, _target_y, _elbow_x, _box_mid_y);
    var _line_start_x = _target_x + lengthdir_x(_circle_radius, _line_direction);
    var _line_start_y = _target_y + lengthdir_y(_circle_radius, _line_direction);
    var _previous_alpha = draw_get_alpha();

    draw_set_alpha(0.28);
    draw_set_color(c_black);
    draw_circle(_target_x, _target_y, _circle_radius, false);
    draw_rectangle(_box_left, _box_top, _box_right, _box_bottom, false);

    draw_set_alpha(0.72);
    draw_set_color(c_lime);
    for (var i = -1; i <= 1; i++)
    {
        draw_line(_line_start_x, _line_start_y + i, _elbow_x, _box_mid_y + i);
        draw_line(_elbow_x, _box_mid_y + i, _box_edge_x, _box_mid_y + i);
        draw_rectangle(_box_left + i, _box_top + i, _box_right - i, _box_bottom - i, true);
    }
    draw_circle(_target_x, _target_y, _circle_radius - 2, true);
    draw_circle(_target_x, _target_y, _circle_radius - 1, true);
    draw_circle(_target_x, _target_y, _circle_radius, true);

    draw_set_alpha(0.82);
    draw_set_font(fnt_terminal_small);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text_ext(_box_left + 28, _box_mid_y, _callout.message, 28, _callout.box_width - 56);
    draw_set_alpha(_previous_alpha);
    draw_set_valign(fa_top);
    draw_set_font(fnt_terminal);
}
