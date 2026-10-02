function terminal_value(_xpos, _ypos, _label, _value, _value_offset)
{
    // Default spacing if no custom offset is supplied
    if (is_undefined(_value_offset))
    {
        _value_offset = 300;
    }

    draw_text(
        _xpos,
        _ypos,
        _label
    );

    draw_text(
        _xpos + _value_offset,
        _ypos,
        string(_value)
    );
}