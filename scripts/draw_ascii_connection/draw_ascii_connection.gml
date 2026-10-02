function draw_ascii_connection(
    _x1,
    _y1,
    _x2,
    _y2,
    _box_width,
    _box_height
)
{
    draw_set_color(c_lime);
    draw_set_font(fnt_ascii);

    var char_width =
        string_width("M");

    var char_height =
        string_height("M");


    var center_x1 =
        _x1 + (_box_width / 2);

    var center_y1 =
        _y1 + (_box_height / 2);

    var center_x2 =
        _x2 + (_box_width / 2);

    var center_y2 =
        _y2 + (_box_height / 2);


    // HORIZONTAL CONNECTION
    if (_y1 == _y2)
    {
        var start_x;
        var end_x;


        if (_x2 > _x1)
        {
            start_x =
                _x1 + _box_width;

            end_x =
                _x2;
        }
        else
        {
            start_x =
                _x2 + _box_width;

            end_x =
                _x1;
        }


        var connection =
            "";

        var count =
            floor(
                (end_x - start_x)
                / char_width
            );


        for (var i = 0; i < count; i++)
        {
            connection += "-";
        }


        draw_text(
            start_x,
            center_y1,
            connection
        );
    }


    // VERTICAL CONNECTION
    else if (_x1 == _x2)
    {
        var start_y;
        var end_y;


        if (_y2 > _y1)
        {
            start_y =
                _y1 + _box_height;

            end_y =
                _y2;
        }
        else
        {
            start_y =
                _y2 + _box_height;

            end_y =
                _y1;
        }


        var count =
            floor(
                (end_y - start_y)
                / char_height
            );


        for (var i = 0; i < count; i++)
        {
            draw_text(
                center_x1,
                start_y + i * char_height,
                "|"
            );
        }
    }
}