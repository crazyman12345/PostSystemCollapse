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
		
		case "money":
			inventory_add("cash",10000);
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
			
		case "debug_start_combat":
			debug_start_combat(args);
			break;
			
		case "god_trader":
			global.admin_trader_enabled = true;
			break;
		
		case "unlock_tables":
			debug_command_unlock_tables();
			debug_log_add("Tables unlocked");
			break;
		
        default:
            debug_log_add(
                "Unknown command: "
                + command
            );
            break;
    }
}