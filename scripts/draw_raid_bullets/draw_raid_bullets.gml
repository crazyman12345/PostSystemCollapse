function draw_raid_bullets()
{
    for (var i = 0; i < array_length(raid_bullets); i++)
    {
        var b = raid_bullets[i];

        var _len = 6;
        var _wid = 2;

        var _x1 = b.bx + lengthdir_x(-_len * 0.5, b.bdirection);
        var _y1 = b.by + lengthdir_y(-_len * 0.5, b.bdirection);

        var _x2 = b.bx + lengthdir_x(_len * 0.5, b.bdirection);
        var _y2 = b.by + lengthdir_y(_len * 0.5, b.bdirection);

        var _px = lengthdir_x(_wid * 0.5, b.bdirection + 90);
        var _py = lengthdir_y(_wid * 0.5, b.bdirection + 90);

        // BLACK OUTLINE
        draw_set_color(c_black);

        draw_triangle(
            _x1 - _px - 1, _y1 - _py - 1,
            _x2 - _px - 1, _y2 - _py - 1,
            _x2 + _px + 1, _y2 + _py + 1,
            false
        );

        draw_triangle(
            _x1 - _px - 1, _y1 - _py - 1,
            _x2 + _px + 1, _y2 + _py + 1,
            _x1 + _px + 1, _y1 + _py + 1,
            false
        );

        // YELLOW BULLET
        draw_set_color(c_yellow);

        draw_triangle(
            _x1 - _px, _y1 - _py,
            _x2 - _px, _y2 - _py,
            _x2 + _px, _y2 + _py,
            false
        );

        draw_triangle(
            _x1 - _px, _y1 - _py,
            _x2 + _px, _y2 + _py,
            _x1 + _px, _y1 + _py,
            false
        );
    }

    draw_set_color(c_white);
}