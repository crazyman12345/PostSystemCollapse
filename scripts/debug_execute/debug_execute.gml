function debug_execute(_command)
{
    if (string_length(_command) <= 0)
    {
        return;
    }

    // Echo command into debug terminal
    debug_log_add(
        "> " + _command
    );

    var args =
        string_split(_command, " ");

    var command =
        string_lower(args[0]);

    switch (command)
    {
        case "give":
            debug_command_give(args);
            break;

        case "items":
            debug_command_items();
            break;

        case "gun_stats":
            debug_command_gun_stats();
            break;

        case "limb_damage":
            debug_command_limb("damage", args);
            break;

        case "limb_fracture":
            debug_command_limb("fracture", args);
            break;

        case "limb_bleed":
            debug_command_limb("bleed", args);
            break;

        case "limb_blackout":
            debug_command_limb("blackout", args);
            break;

        case "limb_reset":
            debug_command_limb("reset", args);
            break;
		
		case "money":
			stash_add("cash",10000);
			break;

        case "help":
            debug_command_help();
            break;
		
		case "clear":
			debug_log = [];
			break;
			
		case "show_mouse":
			debug_show_mouse = !debug_show_mouse;
			break;
			
		case "debug_start_boss":
			debug_start_boss();
			break;
			
		case "god_trader":
			global.admin_trader_enabled = true;
			break;

		case "godmode":
			raid_godmode = !raid_godmode;
			debug_log_add("Godmode " + (raid_godmode ? "enabled" : "disabled"));
			break;

		case "hit_regions":
			raid_hit_region_debug_enabled = !raid_hit_region_debug_enabled;
			debug_log_add("Hit region overlay " + (raid_hit_region_debug_enabled ? "enabled" : "disabled"));
			break;
		
		case "unlock_tables":
			debug_command_unlock_tables();
			debug_log_add("Tables unlocked");
			break;

		case "gun_tuning_mode":
			raid_gun_tuning_toggle();
			break;
		
        default:
            debug_log_add(
                "Unknown command: "
                + command
            );
            break;
    }
}

function debug_command_help()
{
    debug_log_add("help | clear | items | gun_stats | give <item_key> <quantity>");
    debug_log_add("money | show_mouse | debug_start_boss | god_trader");
    debug_log_add("godmode | hit_regions | unlock_tables | gun_tuning_mode");
    debug_log_add("limb_damage <limb> <amount> | limb_fracture <limb>");
    debug_log_add("limb_bleed <limb> <light|heavy> | limb_blackout <limb> | limb_reset <limb|all>");
}
