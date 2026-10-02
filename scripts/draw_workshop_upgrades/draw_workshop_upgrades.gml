function draw_workshop_upgrades(_bench, _key, _x1, _top, _x2, _bottom)
{
    var _y = _top + 140;
    var level = variable_struct_get(workshop_progress, _key);

    draw_text(_x1 + 30, _y, "UPGRADE REQUIREMENTS");
    _y += 50;

    if (level >= _bench.max_level)
    {
        draw_text(_x1 + 30, _y, "MAX LEVEL");
        return;
    }

    var reqs = _bench.upgrade_requirements[level];

    if (level == 0) draw_text(_x1 + 30, _y, "BUILD LEVEL 1");
    else draw_text(_x1 + 30, _y, "LEVEL " + string(level) + " -> LEVEL " + string(level + 1));

    _y += 55;

    for (var i = 0; i < array_length(reqs); i++)
    {
        var req = reqs[i];
        var item = item_get(req.item_key);
        var owned = inventory_get_quantity(req.item_key);

        draw_text(_x1 + 30, _y, item.name);
        draw_text(_x1 + 350, _y, string(owned) + " / " + string(req.quantity));

        _y += 35;
    }

    _y += 35;

    if (workshop_can_upgrade(_key))
    {
        if (level == 0) draw_text(_x1 + 30, _y, "[ENTER] BUILD");
        else draw_text(_x1 + 30, _y, "[ENTER] UPGRADE");
    }
    else
    {
        draw_text(_x1 + 30, _y, "INSUFFICIENT MATERIALS");
    }
}