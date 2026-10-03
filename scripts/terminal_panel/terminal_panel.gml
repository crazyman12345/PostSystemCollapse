function terminal_panel(
    _left,
    _top,
    _width,
    _height,
    _title,
    _active = false
)
{
    var right = _left + _width;
    var bottom = _top + _height;
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_rectangle(
        _left,
        _top,
        right,
        bottom,
        true
    );

    var title_text = "[ " + _title + " ]";

    if (_active)
    {
        title_text =
            ">>> " + title_text + " <<<";
    }

    draw_text(
        _left + _width/2,
        _top + 7,
        title_text
    );
    draw_set_halign(fa_left);
}
