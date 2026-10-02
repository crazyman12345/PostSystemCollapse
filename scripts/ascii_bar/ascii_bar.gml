function ascii_bar(_current, _max, _length = 24)
{
    if (_max <= 0) _max = 1;

    var percent = clamp(_current / _max, 0, 1);
    var filled = floor(percent * _length);
    var text = "[";

    for (var i = 0; i < _length; i++)
    {
        if (i < filled) text += "#";
        else text += "-";
    }

    text += "]";
    return text;
}