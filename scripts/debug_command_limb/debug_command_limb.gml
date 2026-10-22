function debug_command_limb(_action, _args)
{
    if (array_length(_args) < 2)
    {
        debug_log_add("Usage: limb_" + _action + " <limb>");
        return;
    }

    var _limb_name = string_lower(_args[1]);
    if (_action == "reset" && _limb_name == "all")
    {
        for (var i = 0; i < array_length(health_limbs); i++) debug_limb_reset(i);
        debug_log_add("Reset all limbs.");
        return;
    }

    var _limb_index = debug_limb_index_from_name(_limb_name);
    if (_limb_index < 0)
    {
        debug_log_add("Unknown limb: " + _limb_name);
        return;
    }

    var _limb = health_limbs[_limb_index];
    switch (_action)
    {
        case "damage":
            if (array_length(_args) < 3)
            {
                debug_log_add("Usage: limb_damage <limb> <amount>");
                return;
            }

            var _amount = real(_args[2]);
            if (_amount <= 0)
            {
                debug_log_add("Damage must be greater than 0.");
                return;
            }

            player_health_damage_limb(_limb_index, _amount, false);
            debug_log_add("Damaged " + _limb.name + " by " + string(_amount) + ".");
        break;

        case "fracture":
            if (!player_health_limb_can_fracture(_limb_index))
            {
                debug_log_add(_limb.name + " cannot be fractured.");
                return;
            }

            health_limbs[_limb_index].fractured = true;
            save_mark_dirty();
            debug_log_add("Fractured " + _limb.name + ".");
        break;

        case "bleed":
            if (array_length(_args) < 3)
            {
                debug_log_add("Usage: limb_bleed <limb> <light|heavy>");
                return;
            }

            var _bleed_name = string_lower(_args[2]);
            var _bleed_type = _bleed_name == "light"
                ? LimbBleedState.LIGHT
                : (_bleed_name == "heavy" ? LimbBleedState.HEAVY : LimbBleedState.NONE);
            if (_bleed_type == LimbBleedState.NONE)
            {
                debug_log_add("Bleed type must be light or heavy.");
                return;
            }

            player_health_add_bleed(_limb_index, _bleed_type);
            debug_log_add("Applied " + _bleed_name + " bleed to " + _limb.name + ".");
        break;

        case "blackout":
            health_limbs[_limb_index].hp = 0;
            player_health_update_limb_state(health_limbs[_limb_index]);
            save_mark_dirty();
            debug_log_add("Blacked out " + _limb.name + ".");
        break;

        case "reset":
            debug_limb_reset(_limb_index);
            debug_log_add("Reset " + _limb.name + ".");
        break;
    }
}

function debug_limb_index_from_name(_name)
{
    switch (_name)
    {
        case "head": return PlayerLimb.HEAD;
        case "chest": return PlayerLimb.CHEST;
        case "left_arm": case "leftarm": case "larm": return PlayerLimb.LEFT_ARM;
        case "right_arm": case "rightarm": case "rarm": return PlayerLimb.RIGHT_ARM;
        case "left_leg": case "leftleg": case "lleg": return PlayerLimb.LEFT_LEG;
        case "right_leg": case "rightleg": case "rleg": return PlayerLimb.RIGHT_LEG;
    }
    return -1;
}

function debug_limb_reset(_limb_index)
{
    var _limb = health_limbs[_limb_index];
    _limb.hp = _limb.max_hp;
    _limb.fractured = false;
    _limb.bleeds = [];
    _limb.bleed = LimbBleedState.NONE;
    player_health_update_limb_state(_limb);
    health_limbs[_limb_index] = _limb;
    save_mark_dirty();
}
