function raid_room_movement_blocked()
{
    var junction = raid_junction_get(raid.junction_key);

    for (var i = 0; i < array_length(junction.actions); i++)
    {
        var action = junction.actions[i];

        if (action.action_type != RaidActionType.START_COMBAT) continue;
        if (!variable_struct_exists(action, "blocks_movement") || !action.blocks_movement) continue;
        if (raid_action_completed(action.action_key)) continue;

        return true;
    }

    return false;
}