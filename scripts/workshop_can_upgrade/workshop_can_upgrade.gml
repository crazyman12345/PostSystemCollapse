function workshop_can_upgrade(_bench_key)
{
    var reqs = workshop_get_upgrade_requirements(_bench_key);

    for (var i = 0; i < array_length(reqs); i++)
    {
        var req = reqs[i];
        if (inventory_get_quantity(req.item_key) < req.quantity) return false;
    }

    return true;
}