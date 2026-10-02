function draw_ascii_block(
    _ascii_array,
    _x,
    _y,
    _line_height
)
{
    for (
        var i = 0;
        i < array_length(_ascii_array);
        i++
    )
    {
        draw_text(
            _x,
            _y + (i * _line_height),
            _ascii_array[i]
        );
    }
}