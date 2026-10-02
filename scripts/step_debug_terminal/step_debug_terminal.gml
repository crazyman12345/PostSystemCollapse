function step_debug_terminal(){
if (keyboard_check_pressed(vk_f1))
{
    debug_console_open = !debug_console_open;
    debug_input = "";
	keyboard_string = "";
}

if (keyboard_check_pressed(vk_f2))
{
    debug_show_mouse = !debug_show_mouse;
}
if (debug_console_open)
{
    debug_input = keyboard_string;

    if (keyboard_check_pressed(vk_enter))
    {
        debug_execute(debug_input);

        keyboard_string = "";
        debug_input = "";
    }

    if (keyboard_check_pressed(vk_escape))
    {
        debug_console_open = false;

        keyboard_string = "";
        debug_input = "";
    }

    // Don't process normal game controls
	exit;
}
}