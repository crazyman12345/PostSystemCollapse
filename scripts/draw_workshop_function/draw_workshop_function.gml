function draw_workshop_function(_bench, _key, _x1, _top, _x2, _bottom)
{
    var y1 = _top + 140;

    draw_text(_x1 + 30, y1, _bench.function_name);
    y1 += 50;

    var level = variable_struct_get(workshop_progress, _key);

    if (level <= 0)
    {
        draw_text(_x1 + 30, y1, "THIS BENCH HAS NOT BEEN BUILT.");
        return;
    }
if (_key == "salvage_bench")
{
    draw_workshop_salvage(_x1, _top, _x2, _bottom);
    return;
}
    draw_text(_x1 + 30, y1, "NOT YET ADDED");

}