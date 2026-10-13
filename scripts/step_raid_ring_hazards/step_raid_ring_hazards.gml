function step_raid_ring_hazards()
{
    for (var i = array_length(raid_ring_hazards) - 1; i >= 0; i--)
    {
        var _ring = raid_ring_hazards[i];
        _ring = ring_attack_update(_ring);

        if (raid_player_death_active)
        {
            raid_ring_hazards[i] = _ring;
            return;
        }

        if (_ring.active)
            raid_ring_hazards[i] = _ring;
        else
            array_delete(raid_ring_hazards, i, 1);
    }
}
