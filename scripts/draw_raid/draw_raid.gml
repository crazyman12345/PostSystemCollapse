function draw_raid()
{
    draw_set_color(c_black);
    draw_rectangle(0, 0, 1920, 1080, false);
    raid_floor_draw();

    if (raid.state != RaidState.ENTERING)
    {
        draw_raid_room_border();
        blood_surface_draw();
    }

    if (raid.state == RaidState.DEATH)
    {
        draw_raid_enemy_death_effects();
        draw_raid_player();
        return;
    }

    // Arena
    //draw_set_color(c_lime);
    //draw_rectangle(
    //    raid_room_x1,
    //    raid_room_y1,
    //    raid_room_x2,
    //    raid_room_y2,
    //    true
    //);
	draw_raid_lootables();
	draw_raid_ground_items();
	draw_raid_extract();
	draw_raid_enemy_death_effects();
    draw_raid_player();
	draw_raid_gun();
	draw_raid_lootable_prompt();
	draw_raid_ground_item_prompt();
    draw_raid_enemies();
    draw_raid_bullets();
    draw_raid_enemy_bullets();
    draw_raid_ring_hazards();
	draw_raid_door_overlay();
	draw_raid_doors();


	smoke_draw();


    if (raid.state == RaidState.ENTERING)
        draw_raid_room_border();

}

function draw_raid_player_death_screen()
{
    if (raid.state != RaidState.DEATH || raid_player_death_phase < 2) return;

    var _gui_width = display_get_gui_width();
    var _gui_height = display_get_gui_height();
    var _alpha = raid_player_death_phase == 2
        ? clamp(raid_player_death_timer / 20, 0, 1)
        : 1;
    var _center_x = _gui_width * 0.5;
    var _center_y = _gui_height * 0.5;

    draw_set_alpha(0.62 * _alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_width, _gui_height, false);
    draw_set_alpha(_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_terminal);
    draw_set_color(make_color_rgb(145, 35, 35));
    draw_text_transformed(_center_x, _center_y - 80, "YOU DIED!", 1.7, 1.7, 0);
    draw_set_color(c_white);
    draw_text_transformed(_center_x, _center_y + 10, "ALL ITEMS LOST", 0.85, 0.85, 0);

    if (raid_player_death_phase >= 3)
    {
        draw_set_color(c_lime);
        draw_text_transformed(_center_x, _center_y + 90, "PRESS ENTER TO CONTINUE", 0.58, 0.58, 0);
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
