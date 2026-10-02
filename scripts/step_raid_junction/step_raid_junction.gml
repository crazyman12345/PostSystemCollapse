function step_raid_junction()
{
    var actions =
        raid_get_available_actions();
		
	  raid.junction_action_index = clamp(raid.junction_action_index, 0, max(0, array_length(actions) - 1));

    if (array_length(actions) <= 0)
    {
        return;
    }


    raid.junction_action_index =
        terminal_menu_input(
            raid.junction_action_index,
            array_length(actions)
        );


    if (keyboard_check_pressed(vk_enter))
    {
        var selected_action =
            actions[
                raid.junction_action_index
            ];


        if (!raid_action_requirements_met(
            selected_action
        ))
        {
            log_add(
                "Requirements not met."
            );

            return;
        }


        raid_start_action(
            selected_action
        );
    }
}