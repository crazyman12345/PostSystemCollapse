function draw_ascii_rectangle(_x1, _y1, _x2, _y2)
{
    draw_set_color(c_lime);
    draw_set_font(fnt_ascii);

    var char_width = string_width("M");
    var char_height = string_height("M");

    var width_chars =
        max(2, floor((_x2 - _x1) / char_width));

    var height_chars =
        max(2, floor((_y2 - _y1) / char_height));


    // Top and bottom
    var horizontal = "+";

    for (var i = 0; i < width_chars - 2; i++)
    {
        horizontal += "-";
    }

    horizontal += "+";


    // Top
    draw_text(
        _x1,
        _y1,
        horizontal
    );


    // Sides
    for (var row = 1; row < height_chars - 1; row++)
    {
        var yy =
            _y1 + row * char_height;

        draw_text(
            _x1,
            yy,
            "|"
        );

        draw_text(
            _x1 + (width_chars - 1) * char_width,
            yy,
            "|"
        );
    }


    // Bottom
    draw_text(
        _x1,
        _y1 + (height_chars - 1) * char_height,
        horizontal
    );
	draw_set_font(fnt_terminal);
}