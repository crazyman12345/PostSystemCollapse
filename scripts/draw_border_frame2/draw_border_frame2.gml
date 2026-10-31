function draw_border_frame2(_left, _top, _width, _height, _small = false)
{
    var _old_alpha = draw_get_alpha();
    var _right = _left + _width;
    var _bottom = _top + _height;
    var _corner = min(_small ? 12 : 18, min(_width, _height) * 0.2);

    // Subtle offset line gives the frame the same recessed look as the old sprites.
    draw_set_alpha(_old_alpha * 0.2);
    draw_border_frame2_path(_left + 2, _top + 2, _right + 2, _bottom + 2, _corner);

    draw_set_alpha(_old_alpha);
    draw_border_frame2_path(_left, _top, _right, _bottom, _corner);

    var _inner = _small ? 3 : 5;
    draw_set_alpha(_old_alpha * (_small ? 0.35 : 0.55));
    draw_border_frame2_path(
        _left + _inner,
        _top + _inner,
        _right - _inner,
        _bottom - _inner,
        max(2, _corner - _inner)
    );

    if (!_small)
    {
        var _accent = min(28, max(8, _corner * 1.5));
        draw_set_alpha(_old_alpha * 0.8);
        draw_line(_left + _corner, _top + 9, _left + _corner + _accent, _top + 9);
        draw_line(_right - _corner - _accent, _top + 9, _right - _corner, _top + 9);
        draw_line(_left + _corner, _bottom - 9, _left + _corner + _accent, _bottom - 9);
        draw_line(_right - _corner - _accent, _bottom - 9, _right - _corner, _bottom - 9);
    }

    draw_set_alpha(_old_alpha);
}

function draw_border_frame2_path(_left, _top, _right, _bottom, _corner)
{
    draw_primitive_begin(pr_linestrip);
    draw_vertex(_left + _corner, _top);
    draw_vertex(_right - _corner, _top);
    draw_vertex(_right, _top + _corner);
    draw_vertex(_right, _bottom - _corner);
    draw_vertex(_right - _corner, _bottom);
    draw_vertex(_left + _corner, _bottom);
    draw_vertex(_left, _bottom - _corner);
    draw_vertex(_left, _top + _corner);
    draw_vertex(_left + _corner, _top);
    draw_primitive_end();
}

function draw_chamfered_sprite(_sprite, _subimage, _left, _top, _width, _height, _corner, _color = c_white, _alpha = 1)
{
    var _right = _left + _width;
    var _bottom = _top + _height;
    var _cut = min(_corner, min(_width, _height) * 0.5);
    var _old_color = draw_get_color();

    // Use the sprite draw path so large sprites split across texture pages render correctly.
    draw_sprite_stretched_ext(_sprite, _subimage, _left, _top, _width, _height, _color, _alpha);

    draw_set_color(state == GameState.HIDEOUT ? global.hideout_panel_color : c_black);
    draw_triangle(_left, _top, _left + _cut, _top, _left, _top + _cut, false);
    draw_triangle(_right, _top, _right - _cut, _top, _right, _top + _cut, false);
    draw_triangle(_right, _bottom, _right - _cut, _bottom, _right, _bottom - _cut, false);
    draw_triangle(_left, _bottom, _left + _cut, _bottom, _left, _bottom - _cut, false);
    draw_set_color(_old_color);
}
