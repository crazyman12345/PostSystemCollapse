function draw_raid()
{
    draw_set_color(c_black);
    draw_rectangle(0, 0, 1920, 1080, false);

    if (!raid.room_entering)
        draw_raid_room_border();

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
    draw_raid_player();
	draw_raid_gun();
	draw_raid_lootable_prompt();
	draw_raid_ground_item_prompt();
	draw_raid_enemy_death_effects();
    draw_raid_enemies();
    draw_raid_bullets();
    draw_raid_enemy_bullets();
    draw_raid_ring_hazards();
	draw_raid_doors();
	draw_raid_door_overlay();


	smoke_draw();


    if (raid.room_entering)
        draw_raid_room_border();

}
