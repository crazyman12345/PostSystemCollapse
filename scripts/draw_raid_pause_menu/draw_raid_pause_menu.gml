function draw_raid_pause_menu(){
	var gui_width = display_get_gui_width();
	var gui_height = display_get_gui_height();
	var fps_options = [60, 120, 144, 165, 240];
	var panel_left = gui_width * 0.25;
	var panel_top = gui_height * 0.3;
	var panel_right = gui_width * 0.75;
	var panel_bottom = gui_height * 0.72;

	draw_set_color(c_black);
	draw_set_alpha(0.75);
	draw_rectangle(0, 0, gui_width, gui_height, false);
	draw_set_alpha(1);

	draw_set_color(c_black);
	draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, false);
	draw_set_color(c_lime);
	draw_rectangle(panel_left, panel_top, panel_right, panel_bottom, true);
	draw_set_halign(fa_center);
	draw_text(gui_width * 0.5, gui_height * 0.38, "PAUSED");

	var leave_text = "LEAVE RAID (LOSE ALL GEAR)";
	var continue_text = "CONTINUE";
	if (raid.pause_menu_index == 0) leave_text = "> " + leave_text + " <";
	if (raid.pause_menu_index == 3) continue_text = "> " + continue_text + " <";

	draw_text(gui_width * 0.5, gui_height * 0.46, leave_text);
	if (raid.pause_menu_index == 1)
	{
		draw_text(gui_width * 0.5 - 140, gui_height * 0.52, ">");
		draw_text(gui_width * 0.5 + 140, gui_height * 0.52, "<");
	}
	draw_text(gui_width * 0.5 - 90, gui_height * 0.52, "FPS:");
	draw_text(gui_width * 0.5 - 35, gui_height * 0.52, "<");
	draw_text(gui_width * 0.5, gui_height * 0.52, string(fps_options[raid.pause_fps_index]));
	draw_text(gui_width * 0.5 + 35, gui_height * 0.52, ">");
	if (raid.pause_menu_index == 2)
	{
		draw_text(gui_width * 0.5 - 140, gui_height * 0.58, ">");
		draw_text(gui_width * 0.5 + 140, gui_height * 0.58, "<");
	}
	draw_text(gui_width * 0.5 - 110, gui_height * 0.58, "MUSIC:");
	draw_text(gui_width * 0.5 - 35, gui_height * 0.58, "<");
	draw_text(gui_width * 0.5, gui_height * 0.58, string(music_volume) + "%");
	draw_text(gui_width * 0.5 + 35, gui_height * 0.58, ">");
	draw_text(gui_width * 0.5, gui_height * 0.64, continue_text);

	draw_text(gui_width * 0.5, gui_height * 0.69, "W/S OR MOUSE: SELECT    A/D OR ARROWS: CHANGE    ENTER/CLICK: CONFIRM");
	draw_set_halign(fa_left);
}
