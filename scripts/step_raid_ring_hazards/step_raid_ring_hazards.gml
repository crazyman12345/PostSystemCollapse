function step_raid_ring_hazards()
{
    for (var i = array_length(raid_ring_hazards) - 1; i >= 0; i--)
    {
        var _ring = raid_ring_hazards[i];
        _ring = raid_ring_update(_ring);

        if (_ring.active)
            raid_ring_hazards[i] = _ring;
        else
            array_delete(raid_ring_hazards, i, 1);
    }
}
