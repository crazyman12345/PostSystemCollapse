function draw_raid_pause_menu(){
	var gui_width = display_get_gui_width();
	var gui_height = display_get_gui_height();
	var fps_options = [60, 120, 144, 165, 240];
	var panel_left = gui_width * 0.25;
	var panel_top = gui_height * 0.18;
	var panel_right = gui_width * 0.75;
	var panel_bottom = gui_height * 0.88;

	draw_set_color(c_black);
	draw_set_alpha(0.75);
	draw_rectangle(0, 0, gui_width, gui_height, false);
	draw_set_alpha(1);

	draw_set_color(c_black);
	draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, false);
	draw_set_color(c_lime);
	draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, true);
	draw_set_halign(fa_center);
	draw_text(gui_width * 0.5, gui_height * 0.24, "PAUSED");

	var leave_text = "LEAVE RAID (LOSE ALL GEAR)";
	var continue_text = "CONTINUE";
	if (raid.pause_menu_index == 0) leave_text = "> " + leave_text + " <";
	if (raid.pause_menu_index == 7) continue_text = "> " + continue_text + " <";

	draw_text(gui_width * 0.5, gui_height * 0.33, leave_text);
	for (var _option_index = 1; _option_index <= 6; _option_index++)
	{
		if (raid.pause_menu_index != _option_index) continue;
		var _selection_y = gui_height * (0.34 + _option_index * 0.06);
		draw_text(gui_width * 0.5 - 190, _selection_y, ">");
		draw_text(gui_width * 0.5 + 190, _selection_y, "<");
	}
	var _label_x = gui_width * 0.5 - 145;
	var _value_x = gui_width * 0.5;
	var _left_arrow_x = gui_width * 0.5 - 35;
	var _right_arrow_x = gui_width * 0.5 + 35;
	draw_text(_label_x, gui_height * 0.40, "FPS:");
	draw_text(_label_x, gui_height * 0.46, "MUSIC:");
	draw_text(_label_x, gui_height * 0.52, "BLOOM:");
	draw_text(_label_x, gui_height * 0.58, "BLOOM INTENSITY:");
	draw_text(_label_x, gui_height * 0.64, "BLUR RADIUS:");
	draw_text(_label_x, gui_height * 0.70, "BLUR PASSES:");
	for (var _arrow_index = 1; _arrow_index <= 6; _arrow_index++)
	{
		var _arrow_y = gui_height * (0.34 + _arrow_index * 0.06);
		draw_text(_left_arrow_x, _arrow_y, "<");
		draw_text(_right_arrow_x, _arrow_y, ">");
	}
	draw_text(_value_x, gui_height * 0.40, string(fps_options[raid.pause_fps_index]));
	draw_text(_value_x, gui_height * 0.46, string(music_volume) + "%");
	draw_text(_value_x, gui_height * 0.52, raid_bloom_enabled ? "ON" : "OFF");
	draw_text(_value_x, gui_height * 0.58, string_format(raid_bloom_intensity, 1, 1));
	draw_text(_value_x, gui_height * 0.64, string(raid_bloom_blur_radius));
	draw_text(_value_x, gui_height * 0.70, string(raid_bloom_blur_passes));
	draw_text(gui_width * 0.5, gui_height * 0.77, continue_text);

	draw_text(gui_width * 0.5, gui_height * 0.84, "W/S OR MOUSE: SELECT    A/D OR ARROWS: CHANGE    ENTER/CLICK: CONFIRM");
	draw_set_halign(fa_left);
}
