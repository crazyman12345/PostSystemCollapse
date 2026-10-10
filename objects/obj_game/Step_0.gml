frame_scale = (delta_time / 1000000) * 60;

// GameMaker may ignore window changes made immediately after leaving fullscreen.
if (fullscreen_restore_steps >= 0) {
    fullscreen_restore_steps += 1;
    if (fullscreen_restore_steps >= 10) {
        window_enable_borderless_fullscreen(windowed_borderless_fullscreen);
        window_set_showborder(windowed_showborder);
        window_set_rectangle(windowed_x, windowed_y, windowed_width, windowed_height);
        fullscreen_restore_steps = -1;
    }
}

if (keyboard_check_pressed(vk_f11)) {
    if (fullscreen_active) {
        window_set_fullscreen(false);
        fullscreen_restore_steps = 0;
        fullscreen_active = false;
    } else if (fullscreen_restore_steps < 0) {
        windowed_x = window_get_x();
        windowed_y = window_get_y();
        windowed_width = window_get_width();
        windowed_height = window_get_height();
        windowed_showborder = window_get_showborder();
        windowed_borderless_fullscreen = window_get_borderless_fullscreen();

        var _display_rects = window_get_visible_rects(
            windowed_x,
            windowed_y,
            windowed_x + windowed_width,
            windowed_y + windowed_height
        );
        var _target_display = 0;
        var _largest_overlap = -1;

        for (var _display = 0; _display < array_length(_display_rects); _display += 8) {
            var _overlap_width = max(0, _display_rects[_display + 2] - _display_rects[_display]);
            var _overlap_height = max(0, _display_rects[_display + 3] - _display_rects[_display + 1]);
            var _overlap_area = _overlap_width * _overlap_height;

            if (_overlap_area > _largest_overlap) {
                _largest_overlap = _overlap_area;
                _target_display = _display;
            }
        }

        var _display_x = _display_rects[_target_display + 4];
        var _display_y = _display_rects[_target_display + 5];
        var _display_width = _display_rects[_target_display + 6] - _display_x;
        var _display_height = _display_rects[_target_display + 7] - _display_y;
        var _target_is_primary = (_display_x == 0 && _display_y == 0);

        window_set_fullscreen(false);
        window_enable_borderless_fullscreen(!_target_is_primary);
        window_set_rectangle(_display_x, _display_y, _display_width, _display_height);
        window_set_fullscreen(true);
        fullscreen_active = true;
    }
}
if (!(state == GameState.RAID && raid.active && raid.room_entering))
    step_debug_terminal();
if debug_console_open exit;
	

if (!(state == GameState.RAID && raid.active && raid.room_entering))
    step_handle_shortcuts();

if (overlay_mode != OverlayMode.NONE)
{
    step_overlay();
    exit;
}

if (state == GameState.RAID && raid.active && !raid.paused && !raid.room_entering)
{
    raid_hotbar_validate();
    if (keyboard_check_pressed(ord("1"))) raid_hotbar_use(0);
    if (keyboard_check_pressed(ord("2"))) raid_hotbar_use(1);
    if (keyboard_check_pressed(ord("3"))) raid_hotbar_use(2);
    if (keyboard_check_pressed(ord("4"))) raid_hotbar_use(3);
    if (keyboard_check_pressed(ord("5"))) raid_hotbar_use(4);
    if (keyboard_check_pressed(ord("6"))) raid_hotbar_use(5);
    if (raid.hotbar_feedback_timer > 0) raid.hotbar_feedback_timer -= frame_scale;
}

switch (state) {
	case GameState.MAIN_MENU: {
	    step_main_menu();
	    break;
	}
	case GameState.HIDEOUT: {
	    step_hideout();
	    break;
	}
	case GameState.RAID:{
		step_raid();
		if (!raid.room_entering)
			smoke_update();
		break;
	}
}

